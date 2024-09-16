# Sprocket GitHub Action
This action uses [Sprocket](https://github.com/stjude-rust-labs/sprocket) to validate and optionally lint WDL documents.

## Inputs
## lint
**Optional** Whether to run linting in addition to validation. Boolean, valid choices: ["true", "false"]

## Example usage
uses: actions/sprocket-action@v1
with:
    lint: true