# (PART\*) Going forward {.unnumbered}

# Development guidelines {#naming}

## Operator naming convention {-} 

The art of naming is fundamental to programming and here are some guidelines to help.

Here are some examples of operator names:

+ `median_operator`
+ `flowsom_operator` , here the `flowsom` is from the R package `flowsom`
+ `boxplot_shiny_operator`, it is using R shiny

These examples follow naming guidelines, the recommended structure of an operator name is:

`FUNCTION_TYPE_operator`

It is essentially a list of parts separated by an underscore.

Where `FUNCTION` and `operator` is always indicated and the rest depends on the 
operator context.

## GitHub repository {-} 

Please make sure the git repository description outlines a brief functional 
description of the operator. e.g. `calculates a median`.
