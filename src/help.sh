#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::_help.list_functions {
  #
  # Helper to generate a list of OI functions to provide in help output.
  #
  local rv;

  rv="";

  # shellcheck disable=SC2296
  for func in ${(ok)functions}; do
    if [[ "${func}" = oi::* ]] && [[ "${func}" != "oi::_"* ]]; then
      rv+="    ${func}\n"
    fi
  done

  echo "${rv}";
}

function oi::_help {
  #
  # Outputs help info for OI.
  #
  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";
  oi::log "\

  OI library.

  Provides functions to simplify writing scripts.

  Usage: oi [OPTIONS]

  Library Functions:
$(oi::_help.list_functions)

  Arguments:
      -h, --help           show this help message and exit
      --version            show the version of this library and exit

  ";
}
