<img style="margin: 0px" alt="Repository Header Image" src="./assets/header-action.png" />
<hr/>

# Sprocket GitHub Action

This action provides select functionality of the [Sprocket](https://github.com/stjude-rust-labs/sprocket) command line tool for use in CI/CD pipelines.

## `check` | `lint`

The `check` and `lint` subcommands perform static analysis on WDL documents. The `lint: true` option additionally enables linting rules. The `lint` subcommand is an alias for `check` with linting enabled.

### Inputs

#### `lint`

**Optional** Whether to run linting in addition to validation. Boolean, valid choices: ["true", "false"].

#### `exclude-patterns`

**Optional** Comma separated list of patterns to exclude when searching for WDL files.

#### `deny-warnings`

**Optional** If specified, Sprocket `check` will fail if any `warnings` are produced.

#### `deny-notes`

**Optional** If specified, Sprocket `check` will fail if any `notes` are produced.

#### `except`

**Optional** If specified, then the listed rules will be excepted from all `sprocket check` reports. Multiple rules can be specified as a comma-separated list, e.g. `CallInputSpacing,CommandSectionMixedIndentation`. Valid options can be found at: [analysis rules](https://github.com/stjude-rust-labs/wdl/blob/main/wdl-analysis/RULES.md) and [lint rules](https://github.com/stjude-rust-labs/wdl/blob/main/wdl-lint/RULES.md).

### Example usage

```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: check
    lint: true
    exclude-patterns: template,test
    except: TrailingComma,ContainerValue
```

The action `lint` can be specified and is equivalent to specifying `action: check` and `lint: true`.

```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: lint
    exclude-patterns: template,test
    except: TrailingComma,ContainerValue
```

## `validate-inputs`

Validates an input JSON against a task or workflow input schema.

### Inputs

#### wdl_files

A comma-separated list of WDL documents containing a task or workflow for which to check inputs.

#### inputs_files

A matching comma-separated list of JSON format inputs file for the task(s)/workflow(s). Ordering must match `wdl_file` as no checking will be performed.

### Example usage

```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: validate-inputs
    wdl_files: "tools/bwa.wdl"
    inputs_files: "inputs/bwa.json"
```

Multiple files can be specified as well.
```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: validate-inputs
    wdl_files: "tools/bwa.wdl,tools/star.wdl"
    inputs_files: "inputs/bwa.json,inputs/star.wdl"
```

## License and Legal

This project is licensed as either [Apache 2.0][license-apache] or
[MIT][license-mit] at your discretion. Additionally, please see [the
disclaimer](https://github.com/stjude-rust-labs#disclaimer) that applies to all
crates and command line tools made available by St. Jude Rust Labs.

Copyright © 2024-Present [St. Jude Children's Research Hospital](https://github.com/stjude).

[license-apache]: https://github.com/stjude-rust-labs/sprocket-action/blob/main/LICENSE-APACHE
[license-mit]: https://github.com/stjude-rust-labs/sprocket-action/blob/main/LICENSE-MIT
