<img style="margin: 0px" alt="Repository Header Image" src="./assets/header-action.png" />
<hr/>

# Sprocket GitHub Action
This action uses [Sprocket](https://github.com/stjude-rust-labs/sprocket) to validate and optionally lint WDL documents.

## Inputs
### `lint`
**Optional** Whether to run linting in addition to validation. Boolean, valid choices: ["true", "false"]
### `exclude-patterns`
**Optional** Comma separated list of patterns to exclude when searching for WDL files.
### `deny-warnings`
**Optional** If specified, Sprocket `check` will fail if any `warnings` are produced.
### `deny-notes`
**Optional** If specified, Sprocket `check` will fail if any `notes` are produced.
### `except`
**Optional** If specified and `lint`==`true`, then the listed rules will be excepted from all `sprocket lint` checks. Multiple rules can be specified as a comma-separated list, e.g. `CallInputSpacing,CommandSectionMixedIndentation`. Valid options can be found at: https://docs.rs/wdl/latest/wdl/lint/index.html#lint-rules.


## Example usage
```
uses: actions/sprocket-action@v1
with:
    lint: true
    exclude-patterns: template,test
```
