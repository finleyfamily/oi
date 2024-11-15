# OI

[![CI](https://github.com/finleyfamily/oi/actions/workflows/ci.yml/badge.svg)](https://github.com/finleyfamily/oi/actions/workflows/ci.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/enabled-brightgreen?logo=renovatebot&logoColor=%2373afae&label=renovate)](https://developer.mend.io/github/finleyfamily/oi)

OI! A zsh function library based on [bashio](https://github.com/hassio-addons/bashio) but for general use.
While primarily intended for use with zsh, OI should be mostly compatible with Bash.

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
