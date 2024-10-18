#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::exit.error() {
  #
  # Exit the script as failed with an optional error message.
  #
  # Arguments:
  #   $1 Error message (optional)
  #
  local message=${1:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if oi::var.has_value "${message}"; then
    oi::log.fatal "${message}";
  fi

  exit "${__OI_EXIT_NOK}";
}

function oi::exit.die_if_false() {
  #
  # Exit the script when given value is false, with an optional error message.
  #
  # Arguments:
  #   $1 Value to check if false
  #   $2 Error message (optional)
  #
  local value=${1:-};
  local message=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if oi::var.false "${value}"; then
    oi::exit.error "${message}";
  fi
}

function oi::die_if_true() {
  #
  # Exit the script when given value is true, with an optional error message.
  #
  # Arguments:
  #   $1 Value to check if true
  #   $2 Error message (optional)
  #
  local value=${1:-};
  local message=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if oi::var.true "${value}"; then
    oi::exit.error "${message}";
  fi
}

function oi::die_if_empty() {
  #
  # Exit the script when given value is empty, with an optional error message.
  #
  # Arguments:
  #   $1 Value to check if true
  #   $2 Error message (optional)
  #
  local value=${1:-};
  local message=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if oi::var.is_empty "${value}"; then
    oi::exit.error "${message}";
  fi
}

function oi::exit.ok() {
  #
  # Exit the script nicely.
  #
  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";
  exit "${__OI_EXIT_OK}";
}
