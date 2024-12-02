# OI

[![CI](https://github.com/finleyfamily/oi/actions/workflows/ci.yml/badge.svg)](https://github.com/finleyfamily/oi/actions/workflows/ci.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/enabled-brightgreen?logo=renovatebot&logoColor=%2373afae&label=renovate)](https://developer.mend.io/github/finleyfamily/oi)

OI! A zsh function library based on [bashio](https://github.com/hassio-addons/bashio) but for general use.
While primarily intended for use with zsh, OI should be mostly compatible with Bash.

## Installation

OI provides a [Python install script](https://github.com/finleyfamily/oi/blob/master/install.py) to make installation easy.
The install script requires Python ^3.10.

```console
curl -sSL https://raw.githubusercontent.com/finleyfamily/oi/refs/heads/master/install.py | python3 -
```

> ℹ️ **NOTE:** On some systems, `python` may still refer to Python 2 instead of Python 3.
> It is suggested to use the `python3` binary to avoid ambiguity.

To install a specific version of OI, the `--version` option can be passed to the script.

```console
curl -sSL https://raw.githubusercontent.com/finleyfamily/oi/refs/heads/master/install.py | python3 - --version 1.0.0
```

To install a pre-release version of OI, the `--allow-prereleases` flag can be provided.

```console
curl -sSL https://raw.githubusercontent.com/finleyfamily/oi/refs/heads/master/install.py | python3 - --allow-prereleases
```

By default the `.tar.gz` artifact of OI is installed.
If perferred, the `.zip` artifact can be used by passing `--artifact-type zip` to the script.

```console
curl -sSL https://raw.githubusercontent.com/finleyfamily/oi/refs/heads/master/install.py | python3 - --artifact-type zip
```

To uninstall OI, pass the `--uninstall` flag to the script.

```console
curl -sSL https://raw.githubusercontent.com/finleyfamily/oi/refs/heads/master/install.py | python3 - --uninstall
```

### Adding OI to your PATH

The install script creates an `oi` symlink in a well-known, platform-specific directory:

- `$HOME/.local/bin` on Linux/Unix/macOS

If this directory is not present in your `PATH`, it should be added.

Alternatively, the full path to the OI script can always be used:

- `~/.local/lib/oi/oi` on Linux/Unix/macOS

### Updating

To update OI, simply follow the steps in [Installation](#installation) section again.

## Usage

Configuring a zsh script to use the OI library is fairly easy. Simply replace the shebang of your script with from `zsh` to `oi`.

Before:

```shell
#! /usr/bin/env bash

echo "[INFO] Hello world!";
```

After:

```shell
#! /usr/bin/env oi

oi::log.info "Hello world!";
```

## Functions

The best way to see all the available functions and their documentation is to look through the different modules in [`src/`](./src/).
Each module has it's own file and each function has been documented inside the codebase.

Once installed, you can also use `oi --help` to view a list of all available functions.
