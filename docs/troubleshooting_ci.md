# CI and Github Actions

## Test not found

`operator.run.test.not.found`

## Wrong relations

`task.test.operator.bad.nRelations`

## Wrong nCols / nRows

`task.test.operator.bad.nCols` 
`task.test.operator.bad.nRows`

## Wrong column names

`task.test.operator.bad.column.names`

Maybe you've added or renamed a column in the latest version of the operator? In
that case, the reference table should be updated accordingly.

## Wrong column type

`task.test.operator.bad.column.type`

* Check that .ri and .ci factors are output as integers in your operators.
* If another factor (for example, a cluster ID), tercen test will expect is to be
a double. In that case, you need to provide a schema file. If you use
tim to genenerate your test, you can use the XXX argument to the build_test_data 
function.

<!-- Examples: -->
<!-- * X operator -->
<!-- * X operator, ci and ri -->

### Wrong values

`task.test.operator.bad.value`

This error occurs when a value value is different between the reference table and 
the computed table. It gives you the row number and both values to help
finding the issue.

### Wrong correlation

`task.test.operator.bad.correlation`

### Untrusted git

`tercen.forbidden.untrusted.git`
