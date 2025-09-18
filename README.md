<img style="margin: 0px" alt="Repository Header Image" src="./assets/header-action.png" />
<hr/>

# Sprocket GitHub Action

This action provides select functionality of the [Sprocket](https://github.com/stjude-rust-labs/sprocket) command line tool for use in CI/CD pipelines.

## Actions

The default `action` is to `sprocket check` all WDL documents found in the workspace.

### `check` | `lint`

The `check` and `lint` subcommands perform static analysis on WDL documents. The `lint: true` option additionally enables linting rules. The `lint` subcommand is an alias for `check` with linting enabled.

#### Inputs

##### `lint`

**Optional** Whether to run linting in addition to validation. Boolean, valid choices: ["true", "false"].

##### `exclude-patterns`

**Optional** Comma separated list of patterns to exclude when searching for WDL files.

##### `deny-warnings`

**Optional** If specified, Sprocket `check` will fail if any `warnings` are produced.

##### `deny-notes`

**Optional** If specified, Sprocket `check` will fail if any `notes` are produced.

##### `except`

**Optional** If specified, then the listed rules will be excepted from all `sprocket check` reports. Multiple rules can be specified as a comma-separated list, e.g. `CallInputSpacing,CommandSectionMixedIndentation`. Valid options can be found at: [analysis rules](https://github.com/stjude-rust-labs/wdl/blob/main/wdl-analysis/RULES.md) and [lint rules](https://github.com/stjude-rust-labs/wdl/blob/main/wdl-lint/RULES.md).

#### Example usage

```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: check
    lint: true
    exclude-patterns: template,test
    except: TrailingComma,ContainerUri
```

The action `lint` can be specified and is equivalent to specifying `action: check` and `lint: true`.

```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: lint
    exclude-patterns: template,test
    except: TrailingComma,ContainerUri
```

### `validate`

Validates an input JSON against a task or workflow input schema.

#### Inputs

##### wdl_files

A comma-separated list of WDL documents containing a task or workflow for which to check inputs.

##### inputs_files

A matching comma-separated list of JSON format inputs file for the task(s)/workflow(s). Ordering must match `wdl_files` as no checking will be performed.

#### Example usage

```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: validate
    wdl_files: "tools/bwa.wdl"
    inputs_files: "inputs/bwa.json"
```

Multiple files can be specified as well.
```yaml
uses: stjude-rust-labs/sprocket-action@main
with:
    action: validate
    wdl_files: "tools/bwa.wdl,tools/star.wdl"
    inputs_files: "inputs/bwa.json,inputs/star.wdl"
```

## Configuration

The Sprocket GitHub action will load a `sprocket.toml` in the root of your repository, and that can be used to have the same settings in your local development environment as your CI environment. All optional inputs to this GitHub Action (aside from `action`  and `skip-config-search`) can be supplied in your TOML instead.

See the [configuration overview](https://sprocket.bio/configuration/overview.html) on [sprocket.bio](https://sprocket.bio/) for more information.

### Disabling implicit config loading

You can set `skip-config-search: true` to enable the `--skip-config-search` Sprocket option, which disables the normal configuration search. This can be used with `explicit-config-path` to load only the specified configuration file.

### Setting an explicit config path

The `explicit-config-path` can be used if your config TOML is not in the root of the repository or you want to add CI specific configuration. The TOML found at this location will be the highest priority configuration. See our documentation about [configuration load order](https://sprocket.bio/configuration/overview.html#load-order) for more information.

## License and Legal

This project is licensed as either [Apache 2.0][license-apache] or
[MIT][license-mit] at your discretion. Additionally, please see [the
disclaimer](https://github.com/stjude-rust-labs#disclaimer) that applies to all
crates and command line tools made available by St. Jude Rust Labs.

Copyright © 2024-Present [St. Jude Children's Research Hospital](https://github.com/stjude).

[license-apache]: https://github.com/stjude-rust-labs/sprocket-action/blob/main/LICENSE-APACHE
[license-mit]: https://github.com/stjude-rust-labs/sprocket-action/blob/main/LICENSE-MIT
