# Using `tim` {#tim}

`tim` is an R package that includes utilities to facilitate operator development in Tercen Studio.

## Development workflow utilities

```
tim::set_workflow_step_ids(data_step_url)
tim::set_tercen_credentials()
```

## Test utilities

__Populate test data:__

```
tim::build_test_data(out_table = out_table, ctx = ctx, test_name = "test1")
```

__Check test data:__

```
tim::check_test_local(out_table = out_table, test_name = "test1")
```

## Operator folder utilities

__Populate GitHub workflow files:__

```
tim::populate_gh_workflow(type = "R")
tim::populate_gh_workflow(type = "docker")
```
