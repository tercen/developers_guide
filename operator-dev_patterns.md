# Common patterns

This section outlines common development patterns encountered while developing
operators in Tercen.

## Output data

### One table

Coming soon.

__Example__: [Mean operator](https://github.com/tercen/mean_operator) and 
[lm operator](https://github.com/tercen/lm_operator).

### List of tables

Coming soon.

__Example__: [PCA operator](https://github.com/tercen/pca_operator).

### Serialised R object

Coming soon.

__Example__: [FlowSOM operator](https://github.com/tercen/flowsom_operator).

###  Serialised file

Coming soon.

__Example__: [Barplot operator](https://github.com/tercen/barplot_operator).

## Output relations

### Per Cell

__Example__: [Mean operator](https://github.com/tercen/mean_operator), [lm operator](https://github.com/tercen/lm_operator).

### Per Row / Per Column

There are two typical cases for creating a relation per row or per column only:

* the output is computed per __observation__. This is the case of clustering 
algorithms that assign each observation to a cluster ID.

* the is computed per __variable__. For example, we want to scale our values and 
perform, this operation per variable or stratifying factor in our dataset.

__Example__: [PCA operator](https://github.com/tercen/pca_operator).

### No relation

This is useful when no relation needs to be made between computed values and existing
data. For example, we can consider two cases where this is relevant:

* the operator computes an end result that cannot be linked to individual input
data points
* the computation must be available to be linked to _any_ data point (for example,
when we want to generate a constant that can be used together with any other data)

__Example__: [Constant operator](https://github.com/tercen/constant_operator).
