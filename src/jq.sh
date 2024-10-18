#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::jq() {
  #
  # Execute a JSON query.
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ -f "${data}" ]]; then
    jq --raw-output -c -M "$filter" "${data}";
  else
    jq --raw-output -c -M "$filter" <<< "${data}";
  fi
}

function oi::jq.exists() {
  #
  # Checks if variable exists (optionally after filtering).
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ $(oi::jq "${data}" "${filter}") = "null" ]]; then
    return "${__OI_EXIT_NOK}";
  fi

  return "${__OI_EXIT_OK}";
}

function oi::jq.has_value() {
  #
  # Checks if data exists (optionally after filtering).
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};
  local value;

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  value=$(oi::jq "${data}" \
    "${filter} | if (. == {} or . == []) then empty else . end // empty");

  if ! oi::var.has_value "${value}"; then
    return "${__OI_EXIT_NOK}";
  fi

  return "${__OI_EXIT_OK}";
}

function oi::jq.is() {
  #
  # Checks if resulting data is of a specific type.
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter
  #   $3 type (boolean, string, number, array, object, null)
  #
  local data=${1};
  local filter=${2};
  local type=${3};
  local value;

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  value=$(oi::jq "${data}" \
    "${filter} | if type==\"${type}\" then true else false end");

  if [[ "${value}" = "false" ]]; then
    return "${__OI_EXIT_NOK}";
  fi

  return "${__OI_EXIT_OK}";
}

function oi::jq.is_boolean() {
  #
  # Checks if resulting data is a boolean.
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";
  oi::jq.is "${data}" "${filter}" "boolean";
}

function oi::jq.is_string() {
  #
  # Checks if resulting data is a string.
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";
  oi::jq.is "${data}" "${filter}" "string";
}

function oi::jq.is_object() {
  #
  # Checks if resulting data is an object.
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";
  oi::jq.is "${data}" "${filter}" "object";
}

function oi::jq.is_number() {
  #
  # Checks if resulting data is a number.
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";
  oi::jq.is "${data}" "${filter}" "number";
}

function oi::jq.is_array() {
  #
  # Checks if resulting data is an array.
  #
  # Arguments:
  #   $1 JSON string or path to a JSON file
  #   $2 jq filter (optional)
  #
  local data=${1};
  local filter=${2:-};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";
  oi::jq.is "${data}" "${filter}" "array";
}
