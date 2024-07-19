# (PART\*) Python Operator development {.unnumbered}

# Getting familiar with Tercen Studio

## Prerequisites {-}

Before you begin, make sure you have the following prerequisites:

1. Basic understanding of Python programming.
2. Familiarity with Git and GitHub.
3. Tercen Studio development environment installed. Follow the instructions in the [Tercen Studio GitHub repository](https://github.com/tercen/tercen_studio) to set up the environment.

## Getting started {-}

### Step 1: Set Up Development Data Step {-}

* Go to Tercen local instance

* Create a project by clicking on __New project__

* Click on the __From git__ tab and create a new project from `https://github.com/tercen/developers_guide_project` as follows: 

<center><img src="./images/python_dev_1.png" width=700></img></center>

* This action will populate a new project that contains an example dataset (_Crabs_) and a small workflow to get started with development.

* Open the workflow and navigate to the XXX data step

* This a an input data projection we have prepared in the purpose of developing an operator to compute the mean value of the y axis factor, per cell (i.e., the data is grouped using row and column factors).

### Step 2: Set Up Environment and Install Core Requirements {-}

Navigate to VS Code: http://127.0.0.1:8443/

Open a terminal in VS Code Server by clicking on the terminal icon in the lower left corner. Navigate to your cloned repository directory using the `cd` command. Install the core requirements by running the following command:

```bash
pip3 install -r requirements.txt
```

### Step 3: Interact with data through the API {-}

The first thing we'll do is to interactively work with the data we have projected in the crosstab.

To do so, you can get from the data step URL the __workflow ID__ and the __data step ID__. Open the `main.py` file 
and paste the following code:

```python
from tercen.client import context as ctx
import numpy as np

tercenCtx = ctx.TercenContext(
    workflowId="YOUR_WORKFLOW_ID",
    stepId="YOUR_STEP_ID",
    username="admin", # if using the local Tercen instance
    password="admin", # if using the local Tercen instance
    serviceUri="http://tercen:5400/" # if using the local Tercen instance 
)
```

Execute this code (Shift + Enter) in the Python console after having replaced the workflow and step IDs.

_What does it do?_

Now that we have initialised the __Tercen context__, we can interact with the data step. Let's start by __selecting__ some data:

```python
tercenCtx.select(['.y'])
```

```python
tercenCtx.select(['.y', '.ci', '.ri'])
```

* Check the table in the crosstab. It contains the data that has been queried. You can look at it to get some inspiration.


Now try to run the following lines of code:

```python
tercenCtx.cselect()
tercenCtx.rselect()
tercenCtx.colors()

```

Now you can play around with the API and check the output of various functions. What do they do ?

Here is a description of the most commonly used ones:

* `select()`
* `cselect()`
* `rselect()`
* `cnames`
* `rnames`
* `colors`
* `labels`
* `addNamespace()`
* `save()`

# Developing a Python Operator

In this tutorial, we will walk you through the process of developing a Python operator for Tercen. We will cover the entire development workflow, from setting up your environment to installing and using your operator in Tercen.

Building an operator requires to go through the following steps:

* Design the operator
* Setup the github repository
* Setup the input projection
* Connecting to Tercen
* Develop and test
* Manage input settings
* Manage dependencies
* Deployment

## Development Workflow {-}

### [OPTIONAL] Step 1: Create a New Git Repository {-}

Start by creating a new Git repository for your Python operator. You can use the [template Python operator repository](https://github.com/tercen/template-python-operator) as a starting point. You can either fork the repository or create a new one based on the template.

### Step 2: Open VS Code Server {-}

Open your Tercen Studio development environment and access the VS Code Server by navigating to: `http://127.0.0.1:8443` in your web browser.

### [OPTIONAL] Step 3: Clone the Repository {-}

In VS Code Server, open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`) and search for the "Clone from GitHub" command. Provide the URL of your newly created Git repository and choose a location to clone it into.

__If you were not able to create a GitHub repository__, you can clone the template repository directly. You will be able to experiment with the API and follow this tutorial but you won't be able to push changes and install the operator.

### Step 4: Set Up Environment and Install Core Requirements {-}

Open a terminal in VS Code Server by clicking on the terminal icon in the lower left corner. Navigate to your cloned repository directory using the `cd` command. Install the core requirements by running the following command:

```bash
pip3 install -r requirements.txt
```

### Step 5: Develop Your Operator with a Real-Life Example {-}

Start developing your operator by creating a Python script in the cloned repository directory. Create a new Python script, for example, `main.py`, and paste the following code:

```python
from tercen.client import context as ctx
import numpy as np

tercenCtx = ctx.TercenContext()

# Select relevant columns and create a pandas DataFrame
df = (
    tercenCtx
    .select(['.y', '.ci', '.ri'], df_lib="polars")
    .groupby(['.ci', '.ri'])
    .mean()
    .rename({".y": "mean"})
)

# Add namespace and save the computed mean per cell
df = tercenCtx.add_namespace(df)
tercenCtx.save(df)
```

Let's break down the code step by step to understand its functionality:

```python
from tercen.client import context as ctx
import numpy as np
```

This section of the code imports the necessary modules. `tercen.client.context` provides the Tercen context for interacting with the environment, while `numpy` is a popular library for numerical computations in Python.

```python
tercenCtx = ctx.TercenContext()
```

Here, an instance of the `TercenContext` class is created. This context facilitates interaction with the Tercen environment, including data access and operations.

```python
df = (
    tercenCtx
    .select(['.y', '.ci', '.ri'], df_lib="polars")
    .groupby(['.ci', '.ri'])
    .mean()
    .rename({".y": "mean"})
)
```

This section performs a series of operations on the data:

1. `.select(['.y', '.ci', '.ri'], df_lib="polars")`: Selects columns '.y', '.ci', and '.ri' from the data. The `df_lib` parameter is set to "polars," indicating that the data is treated as a Polars DataFrame.

2. `.groupby(['.ci', '.ri'])`: Groups the data by columns '.ci' (column index) and '.ri' (row index).

3. `.mean()`: Calculates the mean for the grouped data. This computes the mean value for each group.

4. `.rename({".y": "mean"})`: Renames the column named '.y' to "mean" to reflect that it contains the computed mean values.

The result is a Polars DataFrame named `df` containing the computed mean per cell.

```python
df = tercenCtx.add_namespace(df)
```

This line adds a namespace to the DataFrame using `add_namespace`. This step ensures a unique and data step specific prefix is added to new factors to avoid duplicate factor names in a workflow.

```python
tercenCtx.save(df)
```

Finally, the computed DataFrame is saved using the `save` method of the `TercenContext`. This action makes the calculated mean per cell available for use within the Tercen environment.

### Step 6: Generate Requirements  {-}

If your operator requires additional Python packages, you can generate the requirements.txt file using the following command:

```bash
python3 -m tercen.util.requirements . > requirements.txt
```

### [OPTIONAL] Step 7: Push Changes to GitHub {-}

Commit your changes to your local Git repository and push the changes to GitHub. This will trigger the Continuous Integration (CI) GitHub workflow, which performs automated tests on your operator.

### [OPTIONAL] Step 8: Tag the Repository {-}

Once you are satisfied with your operator's development and testing, you can tag your repository. Tagging will trigger the Release GitHub workflow, which will create a release for your operator.

### Conclusion {-}

Congratulations! You have successfully developed and deployed a Python operator for Tercen.
By following these steps, you can create custom data processing operators to extend the functionality 
of Tercen and streamline your data analysis workflows. Remember to consult the Tercen documentation for more
 details and advanced features. Happy coding!
