# Patterns for Plot Operators

## Introduction

This tutorial demonstrates how to use Python with the `tercen` library to create custom plot operators. It covers:

1. Connecting to the Tercen workflow to select data.
2. Creating plots with Seaborn.
3. Enhancing plots with advanced techniques like facet grids.
4. Handling metadata for rows and columns.
5. Saving and exporting plots back to Tercen.

---

## Basic Scatter Plot

### Connecting to Tercen

Use `TercenContext` to establish a connection with your Tercen workflow. Provide the required parameters, such as `workflowId`, `stepId`, `authToken`, and `serviceUri`.

```python
from tercen.client import context as ctx

context = ctx.TercenContext(
    workflowId="WORKFLOW_ID",
    stepId="STEP_ID",
    authToken="TOKEN",
    serviceUri="SERVICE_URI"  
)
```

---

### Accessing Operator Properties

Tercen allows custom operator configurations using properties. Here, the `title` property is retrieved with a default value:

```python
plot_title = context.operator_property("title", str, default="My plot title")
```

You can now use this property (e.g., as a plot title).

---

### Selecting Data

The `select` method retrieves data from Tercen's workflow. For example, to extract `x` and `y` axis data:

```python
df = context.select([".x", ".y"], df_lib="pandas")
```

The `df_lib="pandas"` parameter specifies the data format, making it compatible with the Pandas library. The default setting will load a Polars data frame.

---

### Making the Plot

Visualize the data using Seaborn:

```python
import seaborn as sns

p = sns.scatterplot(data=df, x=".x", y=".y", linewidth=0, alpha=0.5, s=0.5)
p.set_xlabel(context.xAxis[0])
p.set_ylabel(context.yAxis[0])
```

This basic scatter plot uses `.x` and `.y` as coordinates and applies axis labels from the Tercen context.

---

## Adding Color to Plots

Use the `colors` attribute from Tercen to include a color dimension in your plot:

```python
df = context.select([".x", ".y"] + context.colors, df_lib="pandas")

p = sns.scatterplot(
    data=df,
    x=".x",
    y=".y",
    hue=context.colors[0],
    palette="deep",
    linewidth=0,
    alpha=0.5,
    s=2
)
```

The `hue` parameter maps the first color channel to the scatter plot. Note that multiple color factors can be specified. Instead of using the first one only like above, one could concatenate all color factors
and use the newly created factor as a "hue". 

---

## Faceted Plots

### Row/Column Facetting

As the crosstab can be stratified by row and column factors, we can do the same in our plot and create a faceted grid:

```python
df = context.select([".x", ".y", ".ci", ".ri"] + context.colors, df_lib="pandas")
g = sns.FacetGrid(df, col=".ci", row=".ri")
g.map(sns.scatterplot, ".x", ".y")
g.set_axis_labels(x_var="X axis", y_var="Y axis")
```

Here:
- `.ci` (column index) and `.ri` (row index) define the facets.
- `FacetGrid` generates a grid of plots.

---

### Dynamic Column and Row Names

Include additional metadata to enhance your facets and not use the row and column indices only:

```python
df_row = context.rselect(df_lib="pandas")
df_row[".ri"] = range(len(df_row))

df_col = context.cselect(df_lib="pandas")
df_col[".ci"] = range(len(df_col))

df_plot = df.merge(df_col, how="left", on=".ci").merge(df_row, how="left", on=".ri")
```

This creates enriched dataframes with merged metadata, suitable for more dynamic faceting.

We need to handle scenarios where column or row names are empty:

```python
cn = context.cnames[0]
if cn == '':
    cn = None

rn = context.rnames[0]
if rn == '':
    rn = None
```

This ensures compatibility with workflows that lack row or column factors.

We can then produce our plot:

```python
g = sns.FacetGrid(df_plot, col=cn, row=rn)
g.map(sns.scatterplot, ".x", ".y")
g.set_axis_labels(x_var="X axis", y_var="Y axis")
```

---

## Saving and Exporting Plots

Finally, you can save the plot as an image and upload it back to Tercen:

```python
from tempfile import NamedTemporaryFile
from tercen.util.helper_functions import image_file_to_df, as_relation, as_join_operator

tmp = NamedTemporaryFile(delete=True, suffix='.png')
g.savefig(tmp)

df_out = image_file_to_df(tmp.name)
rel_out = as_relation(df_out)
context.save_relation(as_join_operator(rel_out, [], []))
```

This pattern uses helper functions to convert the plot into a Tercen-compatible format and save it as a relation.

---

## Conclusion

These development patterns allow you to:

- Retrieve and process data efficiently.
- Create dynamic, customizable plots.
- Leverage Tercen metadata for advanced visualizations.
- Save and integrate results seamlessly back into Tercen workflows.

By mastering these techniques, you can build powerful, reusable visualization operators for collaborative data analysis in Tercen.

