# (PART\*) Troubleshooting {.unnumbered}

# Common operator issues

#### Failed to decode

```
tercen.http.HttpClientService.TercenError: unknown : failed to decode
```

When running the `TercenContext()` function in Python (or `tercenCtx()` in R), this error happens when it is not possible to retrieve data from the specified data step. Common underlying reasons include:
* Data Step has not been saved
* Data Step is already run

In order to fix the issue:
* Reset the data step,
* Save - Refresh - Save the data step,
* Re-run the TercenContext call.
