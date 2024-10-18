#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::fs.directory_exists() {
  #
  # Check whether or not a directory exists.
  #
  # Arguments:
  #   $1 Path to directory
  #
  local directory=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ -d "${directory}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::fs.file_exists() {
  #
  # Check whether or not a file exists.
  #
  # Arguments:
  #   $1 Path to file
  #
  local file=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ -f "${file}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::fs.device_exists() {
  #
  # Check whether or not a device exists.
  #
  # Arguments:
  #   $1 Path to device
  #
  local device=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ -d "${device}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::fs.socket_exists() {
  #
  # Check whether or not a socket exists.
  #
  # Arguments:
  #   $1 Path to socket
  #
  local socket=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ -S "${socket}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}
