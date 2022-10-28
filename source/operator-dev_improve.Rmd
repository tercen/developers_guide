# Improving an operator

Now that we have deployed our R operator for Tercen, we can always improve it! In this chapter we will see how to catch errors, add input parameters (_properties_), and prepare testing for our __linear regression__ operator.

## Error catching {-}

**1. Check the presence of input projection**

For the `lm_operator`, we can check if both _x_ and _y_ axes have been set in the projection, and return an error message to help the user. We can do that using the `try()` function.

```r
ctx <- tercenCtx()

if(inherits(try(ctx$select(".x")), 'try-error')) stop("x axis is missing.")
if(inherits(try(ctx$select(".y")), 'try-error')) stop("y axis is missing.")
```

**2. Catch errors in key processes**

We can also use the `try()` function to catch potential errors in key processes of our operator. In our example, we can for example catch error occuring while running the `lm()` function. Then, we return coefficients only if the model ran successfully. Otherwise, `NaN` are returned.

```r
do.lm <- function(df) {
  out <- data.frame(
    .ri = df$.ri[1],
    .ci = df$.ci[1],
    intercept = NaN,
    slope = NaN
  )
  mod <- try(lm(.y ~ .x, data = df))    # try-catch
  if(!inherits(mod, 'try-error')) {     # get coefficients if lm ran succesfully
    out$intercept <- mod$coefficients[1]
    out$slope <- mod$coefficients[2]
  }
  return(out)
}
```

## Adding properties {-}

Tercen operators can take input parameters (called _properties_). They can be of different types (boolean, enumerated, numeric).

As an example, let's see how to add a property to the `lm_operator`. We will add a parameter to decide whether to omit the intercept in the model or not.

**1. Modify the operator's JSON file to add properties.**

For each property, we have to set values to different attributes:

* `kind`: property kind (`BooleanProperty`, `DoubleProperty`, or `EnumeratedProperty`)

* `name`: name that will be displayed in Tercen

* `defaultValue`: default value taken by the property

* `description`: description to be displayed in Tercen

In our case, the JSON file looks now like this:

```r
{
  "name": "Linear regression",
  "description": "Returns the intercept and slope of a linear regression in a cell",
  "tags": ["linear model"],
  "authors": ["tercen"],
  "urls": ["https://github.com/agouy/lm_operator"],
  "properties": [
  {
    "kind": "BooleanProperty",
    "name": "intercept.omit",
    "defaultValue": false,
    "description": "A logical value indicating whether the intercept should be omitted in the model."
  }
  ]
}
```
**2. Use the property in the R code**

This property can be called in the R operator code as follows:

```r
  intercept.omit <- as.logical(ctx$op.value('intercept.omit'))
  if(intercept.omit) {
    mod <- try(lm(.y ~ .x - 1, data = df))
  } else {
    mod <- try(lm(.y ~ .x, data = df))
  }
```

## Preparing operator testing {-}

It's always good to prepare some tests that could be ran when a new version of Tercen is released.

To include a test, you need to __create a `test` subdirectory__ in your project directory. It must include:

* a test __input file__

* an expected __output file__

* a __`JSON` file__ containing information about the test

For example, a test for our `lm` operator can be created as follow:

```r
# Simulate tercen input based on the CO2 dataset 
# with an x and y-axis, rows and columns
data(CO2)
df <- data.frame(.x = CO2$conc, .y = CO2$uptake, .ri = CO2$Plant, .ci = CO2$Treatment)

# Run the do.lm() function created above to generate the expected output
out <- df %>% select(.ci, .ri, .x, .y) %>%
  group_by(.ri, .ci) %>%
  do(do.lm(.))

# write input and expected output in the test subdirectory
write.csv(CO2, file="./test/CO2.csv", row.names = FALSE, quote = FALSE)
write.csv(out, file="./test/output.csv", row.names = FALSE, quote = FALSE)
```

Now that we have our input and ouput files, we can __create the `JSON` file__ that shall include the following information:

```json
{
  "kind": "OperatorUnitTest",
  "name": "testlm1",
  "namespace": "test",
  "inputDataUri": "CO2.csv",
  "outputDataUri": ["output.csv"],
  "columns": ["Treatment"],
  "rows": ["Plant"],
  "colors": [],
  "labels": [],
  "yAxis": "uptake",
  "xAxis": "conc"
}
```

The `name` attribute is free. Input and output test files names must be assigned to the `inputDataUri` and `inputDataUri`, respectively. Variable names of the input file must be assigned to the `columns`, `rows`, `colors`, `labels`, `yAxis`, `xAxis` attributes. In our case,  `colors` and `labels` are left empty as they are not part of our input.
