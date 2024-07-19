# (PART\*) Python Operator development {.unnumbered}

# Getting familiar with Tercen Studio

* Go to Tercen local instance

* Create a project, upload data and create a new workflow

* Table Step and Data Step


# Developing a Python Operator

In this tutorial, we will walk you through the process of developing a Python operator for Tercen. We will cover the entire development workflow, from setting up your environment to installing and using your operator in Tercen.

## Prerequisites {-}

Before you begin, make sure you have the following prerequisites:

1. Basic understanding of Python programming.
2. Familiarity with Git and GitHub.
3. Tercen Studio development environment installed. Follow the instructions in the [Tercen Studio GitHub repository](https://github.com/tercen/tercen_studio) to set up the environment.

## Development Workflow {-}

### Step 1: Create a New Git Repository {-}

Start by creating a new Git repository for your Python operator. You can use the [template Python operator repository](https://github.com/tercen/template-python-operator) as a starting point. You can either fork the repository or create a new one based on the template.

### Step 2: Open VS Code Server {-}

Open your Tercen Studio development environment and access the VS Code Server by navigating to: `http://127.0.0.1:8443` in your web browser.

### Step 3: Clone the Repository {-}

In VS Code Server, open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`) and search for the "Clone from GitHub" command. Provide the URL of your newly created Git repository and choose a location to clone it into.

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

### Step 7: Push Changes to GitHub {-}

Commit your changes to your local Git repository and push the changes to GitHub. This will trigger the Continuous Integration (CI) GitHub workflow, which performs automated tests on your operator.

### Step 8: Tag the Repository {-}

Once you are satisfied with your operator's development and testing, you can tag your repository. Tagging will trigger the Release GitHub workflow, which will create a release for your operator.

### Conclusion

Congratulations! You have successfully developed and deployed a Python operator for Tercen.
By following these steps, you can create custom data processing operators to extend the functionality 
of Tercen and streamline your data analysis workflows. Remember to consult the Tercen documentation for more
 details and advanced features. Happy coding!
