# (PART\*) R Operator development {.unnumbered}

# General workflow

Lets go through a general approach to create an R operator for Tercen. 
A more detailed walk through (a tutorial) example is outlined in the next 
chapter where a linear regression operator is built from scratch.

Building an operator requires the following sequential steps: 

* Design the operator
* Setup the github repository
* Setup the input projection
* Connecting to Tercen
* Testing 
* Managing input parameters
* Managing R packages
* Deploy


## Design the operator {-}

The first step is to define our __input projection__ and __output relation__. 
In Tercen, each operator shall take as input a table and return a table. Remember:

> "__Table in, table out!__"

To understand the input table and the output table. The input table is defined 
by the data __input projection__ in Tercen and output table is what is computed 
by the operator. The output table (also called the __computed table__) is 
related to the input table by an __output relation__.  

The __input project__ is the projection in the data step which is used by 
the operator. For example a projection is composed of the `y-axis`, `x-axis`,
`row`, `col`, `color`, `label`. This input project determines what is the
structure of the data which is given to the operator. An operator which computes 
a simple `mean` would use a `y-axis`, `row`, `col` projection. This allows 
the `mean` to be computed per cell. A linear regression operator like `lm` might
use a projection with `y-axis`, `x-axis`, and `row`, `col`. This allows the `lm` 
to be computed per cell. 


The __output relation__ is the relation of the calculated output to the 
input values. For example:

* Is the relation per Cell?
* Is the relation per Column?
* Is the relation per Row? 
* Is the relation for All the data?

__Per Cell__ example : Let's say the operator used a projection with `row` and `col` and the operator calculates a `mean` which is computed for each cell (i.e. per row/col), this would be a per cell relationship.

__Per Column__ example: Let's say the operator used a project with `row` and `col` and the operator performed a clustering on the columns, this would be a column relationship.

__for All__ data example: Let's say the operator used a project with `row` and `col` and the operator calculated a total `mean` of all the data (i.e. across all rows and cols), this would be an all data relationship.

**Steps for designing the operator**

* Understand the Tercen concepts
* Look at existing operators
* Decide what variables are needed for the __input projection__
* Decide what values need to be computed and which __output relations__ have to be created


## Set up a GitHub project {-}

All operators currently are developed on GitHub. It is required to have a 
GitHub account to develop an operator, as operator are implemented in a 
GitHub repository.

In order to get started, the easiest way is the use one of the GitHub repository
templates we have prepared:

* [minimal template for R operators](https://github.com/tercen/template_R_operator_lite)
* [template for R operators](https://github.com/tercen/template_R_operator)
* [template for Shiny operators](https://github.com/tercen/template_shiny_operator)
* [template for Docker operators](https://github.com/tercen/simple_docker_operator)
* [template for Python operators](https://github.com/tercen/template_python_operator)

**Steps for starting with the operator repository**

* Get a GitHub account
* Choose an operator name
* Create an operator repository on GitHub based on a template (see above)
* Clone the repo into the local RStudio contained in Tercen Studio

## Setup the input data {-}

This can be done in your local environment or in a cloud instance of Tercen.

* Login to Tercen (either local or cloud)
* Prepare your data by defining a __cross-tab__ projection using a __data step__.
* Note that the project in the data step has URL with this pattern: `/w/workflowId/ds/stepId`, where `workflowId` and `stepId` are __unique workflow and data step identifiers__, respectively. These identifiers will be used in the next step to get data from this data step.

## Connecting to tercen {-}

Once you have cloned the github operator project into your local RStudio and you 
have setup the Tercen data projection, we can code and test our operator locally.

If you wish to test with the local version of Tercen, then you do not require 
to set the `tercen.service` system variable. 

* Load some data up in the local instance of Tercen
* Each data step has a unique`workflowId` and a `stepId` combination.

```
options("tercen.workflowId"= "8a8845f6a5eeff27ce33fd382444de88")
options("tercen.stepId"= "5191724b-3963-4e34-af58-7977cc61e5b1")
```

___Connecting to Tercen cloud___

Additional system variable are required in order to connect to a data step in 
the Tercen cloud.

```
options("tercen.serviceUri"= "https://tercen.com/api/v1/")
options("tercen.username"= "uuuu")
options("tercen.password"= "pppp")
```

Where `uuuu` is the username and `pppp` is the password, these are specific 
to your username and password.


## Managing input parameters {-}

The operator has a file called `operator.json` these define the parameters which
the user can set when using your operator.

Before deploying, please think what parameters are required and modify this file.

## Managing R packages {-}

The newly created operators requires the correct packages to be loaded.
Install the packages your require using the standard install procedures, we
recommend the following:

* install.packages()
* remotes::install_github()

Just before you deploy your operator, it is necessary to setup the package 
management system. A Tercen operator manages its packages using the `renv` system.
The `renv` system allows all the packages you required to be recorded 
in a `renv.lock` file.


To generate this use:

```
renv::init() 
```

This is done before you `push` the repository to github.

## Deploy! {-}

Once you are satisfied with your operator, you can release it.

**Document the operator**

Edit the `README.md` to describe the operator design and usage. The documentation should contain:

* A __general description__ of the operator

* A description of the __input projections__

* A description of the __output relations__

**Prepare operator testing**

It's always good to prepare some unit tests that could be ran when a new version of Tercen is released.

To include a test, you need to __create a `tests` subdirectory__ in your project directory. It must include:

* a test __input file__

* an expected __output file__

* a __`JSON` file__ containing information about the test

**Initiate package version control**

The ability to run an operator with exactly the same packages you used when you developed is essential for reproducible science. In order to ensure reproducibility, you can associate packages and their versions to your operator by initiating a project-local environment with a private libraries in a subdirectory.

**Push it to your GitHub repository**

Once everything is ready, you simply need to push all the modifications to the GitHub repository that you created before.

It is possible that a more secure authentication is required by GitHub
to push your changes the first time. One solution is to get a personal access token
(PAT) from GitHub from [https://github.com/settings/tokens](https://github.com/settings/tokens).
You can click on `Generate new token`, name it and select the `repo` scope. Be
mindful of the expiration setting as well.

Then, you can copy this token and paste it into RStudio after running the following
command in the R console:

```
credentials::set_github_pat()
```

Note that the `credentials` package is installed by default in Tercen Studio.

A good introduction to Git and RStudio is [happygitwithr](https://happygitwithr.com/index.html).


**Install the operator**

If you want to install it directly from `Tercen`, you will need to 
[create a release in GitHub](https://help.github.com/en/github/administering-a-repository/managing-releases-in-a-repository). All the operators are version controlled.

All __operators__ who are on a git repository are installable, 
only the git URL and a tag version number is required for a researcher to
install it in Tercen.
