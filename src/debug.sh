#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

oi::debug() {
  #
  # Checks if we are currently running in debug mode, based on the log module.
  #
  if [[ "${__OI_LOG_LEVEL}" -lt "${__OI_LOG_LEVEL_DEBUG}" ]]; then
    return "${__OI_EXIT_NOK}"
  fi

  return "${__OI_EXIT_OK}"
}
