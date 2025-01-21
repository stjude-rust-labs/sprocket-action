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

**Optional** If specified, then the listed rules will be excepted from all `sprocket check` reports. Multiple rules can be specified as a comma-separated list, e.g. `CallInputSpacing,CommandSectionMixedIndentation`. Valid options can be found at: [analysis rules](https://github.com/stjude-rust-labs/wdl/blob/main/wdl-analysis/RULES.md) and [lint rules](https://github.com/stjude-rust-labs/wdl/blob/main/wdl-lint/RULES.md).

## Example usage

```
uses: stjude-rust-labs/sprocket-action@main
with:
    lint: true
    exclude-patterns: template,test
    except: TrailingComma,ContainerValue
```

## License and Legal

This project is licensed as either [Apache 2.0][license-apache] or
[MIT][license-mit] at your discretion. Additionally, please see [the
disclaimer](https://github.com/stjude-rust-labs#disclaimer) that applies to all
crates and command line tools made available by St. Jude Rust Labs.

Copyright © 2024-Present [St. Jude Children's Research Hospital](https://github.com/stjude).

[license-apache]: https://github.com/stjude-rust-labs/sprocket-action/blob/main/LICENSE-APACHE
[license-mit]: https://github.com/stjude-rust-labs/sprocket-action/blob/main/LICENSE-MIT
