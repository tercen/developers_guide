# Input and Output Patterns

This chapter provides a walkthrough for using advanced input and output operations in Tercen. It demonstrates how to output data frames and relations, 
save files as Tercen tables, and read data from projects. This guide will help you better manage and interact with data in Tercen workflows.

## 1. Setting Up the Tercen Context {-}

Before working with any Tercen workflow, start by setting up the context with `TercenContext`, which connects to your specific Tercen instance.

```python
from tercen.client import context as ctx

ctx = ctx.TercenContext(
    workflowId="your_workflow_id",
    stepId="your_step_id",
    username="admin",
    password="admin",
    serviceUri="http://tercen:5400/"  # for local Tercen instance
)
```

## 2. Output Patterns {-}

### Data Frame Output {-}

Data frames in Tercen are outputted per row, per column, or per cell. Each type of output requires to include a specific column: `.ri` for rows and `.ci` for columns.

#### 2.1 Row-Wise Output {-}

The following code outputs the mean value for each row. It groups the data by `.ri`, calculates the mean, and saves it back to Tercen.

```python
df_per_row = (
    ctx
    .select([".ri", ".y"])
    .groupby([".ri"])
    .mean()
    .rename({'.y': 'mean_rows'})
)

df_per_row = ctx.add_namespace(df_per_row)
ctx.save(df_per_row)
```

#### 2.2 Column-Wise Output {-}

To calculate the mean value for each column, group the data by `.ci`.

```python
df_per_col = (
    ctx
    .select([".ci", ".y"])
    .groupby([".ci"])
    .mean()
    .rename({'.y': 'mean_cols'})
)

df_per_col = ctx.add_namespace(df_per_col)
ctx.save(df_per_col)
```

#### 2.3 Cell-Wise Output {-}

For calculating means per cell, group by both `.ri` and `.ci`.

```python
df_per_cell = (
    ctx
    .select([".ri", ".ci", ".y"])
    .groupby([".ri", ".ci"])
    .mean()
    .rename({'.y': 'mean_cells'})
)

df_per_cell = ctx.add_namespace(df_per_cell)
ctx.save(df_per_cell)
```

#### 2.4 Saving Multiple Data Frames {-}

Multiple tables can be saved as a list in Tercen.

```python
ctx.save([df_per_row, df_per_col, df_per_cell])
```

### 3. Tercen Relation Output {-}

Relations in Tercen support complex data linking, such as joining tables and managing non-standard row/column associations. Relations allow for left joins and merging tables.

Here are the relevant API calls:

1. **Create Relations** using `as_relation()`.
2. **Join Relations** with `left_join_relation()`.
3. **Save Relations** with `save_relation()`.

__Example: Generating a PCA relation with components.__

```r
data.matrix = t(ctx %>% as.matrix())

aPca = data.matrix %>% prcomp(scale = scale, center = center, tol = tol)

maxComp = ifelse(maxComp > 0, min(maxComp, nrow(aPca$rotation)), nrow(aPca$rotation))

npc = length(aPca$sdev)

# pad left pc names with 0 to ensure alphabetic order
pcRelation = tibble(PC = sprintf(paste0("PC%0", nchar(as.character(npc)), "d"), 1:npc)) %>%
    ctx$addNamespace() %>%
    as_relation()

eigenRelation = tibble(pc.eigen.values = aPca$sdev^2) %>% 
    mutate(var_explained = .$pc.eigen.values / sum(.$pc.eigen.values))%>% 
    ctx$addNamespace() %>%
    as_relation()

loadingRelation = aPca$rotation[,1:maxComp] %>%
    as_tibble() %>%
    setNames(0:(ncol(.)-1)) %>%
    mutate(.var.rids = 0:(nrow(.) - 1)) %>%
    pivot_longer(-.var.rids,
                    names_to = ".pc.rids",
                    values_to = "pc.loading",
                    names_transform=list(.pc.rids=as.integer)) %>%
    ctx$addNamespace() %>%
    as_relation() %>%
    left_join_relation(ctx$rrelation, ".var.rids", ctx$rrelation$rids)

scoresRelation = aPca$x[,1:maxComp] %>%
    as_tibble() %>%
    setNames(0:(ncol(.)-1)) %>%
    mutate(.i=0:(nrow(.)-1)) %>%
    pivot_longer(-.i,
                    names_to = ".pc.rids",
                    values_to = "pc.value",
                    names_transform=list(.pc.rids=as.integer)) %>%
    ctx$addNamespace() %>%
    as_relation() %>%
    left_join_relation(ctx$crelation, ".i", ctx$crelation$rids)

# link all 4 relation into one and save 
rels <- pcRelation %>%
    left_join_relation(scoresRelation, pcRelation$rids, ".pc.rids")  %>%
    left_join_relation(eigenRelation, pcRelation$rids, eigenRelation$rids) %>%
    left_join_relation(loadingRelation, pcRelation$rids, ".pc.rids") %>%
    as_join_operator(ctx$cnames, ctx$cnames)
```

### 4. File Output {-}

Tercen supports outputting files, such as images or documents, by first saving them temporarily and then converting them to a Tercen-compatible format.

```python
from tempfile import NamedTemporaryFile
import matplotlib.pyplot as plt

# Save plot as a temporary file
tmp = NamedTemporaryFile(delete=True, suffix='.png')
data_np = df_per_cell["mean_cells"].to_numpy()

plt.hist(data_np, bins=5, edgecolor="black")
plt.xlabel("Value")
plt.ylabel("Frequency")
plt.title("Histogram")
plt.savefig(tmp)

# Convert file to Tercen table
from tercen.util.helper_functions import as_relation

df_plot = as_relation(tmp.name)
ctx.save_relation(df_plot)
```

### 5. Advanced Input: Reading from Project {-}

Tercen enables reading files and documents directly from a project.

1. **Identify Project and Folder IDs** using `workflowId` and `folderId`.
2. **Locate Files** by matching the file name in the project.
3. **Download Documents** using `download()`.

Example: Retrieving a document from the project.

```python
# Get the workflow and Folder ID that contains it
wf = ctx.context.client.workflowService.get(ctx.context.workflowId)
wf.folderId

# Get project ID
projectId = ctx.schema.projectId 
project = ctx.context.client.projectService.get(projectId)
projectUser = project.acl.owner

projectFiles = ctx.client.projectDocumentService.findProjectObjectsByFolderAndName(\
    [projectId, "ufff0", "ufff0"],\
    [projectId, "", ""], useFactory=False, limit=25000 )

fnames = [f.name for f in projectFiles]

## Download a document
my_file_id = [index for index, fname in enumerate(fnames) if 'crabs_file.csv' in fname][0] # First match

# Get Document properties
pf = projectFiles[my_file_id]

pf.name # file name
pf.folderId # folder ID
pf.id # document ID

# Download data and read response
resp = ctx.context.client.fileService.download(pf.id)
resp.read()
# If binary response, must be decoded
```

> **Recommendation:** Avoid manual file retrieval by setting document IDs directly in the workflow input projection.

---

This chapter provides essential steps for managing inputs and outputs within Tercen. Utilize these methods to streamline workflows and enhance data integration capabilities in your Tercen projects.

