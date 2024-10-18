#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::var.true() {
  #
  # Checks if a given value is true.
  #
  # Arguments:
  #   $1 value
  #
  local value=${1:-null};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ "${value}" = "true" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::var.false() {
  #
  # Checks if a given value is false.
  #
  # Arguments:
  #   $1 value
  #
  local value=${1:-null};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ "${value}" = "false" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::var.defined() {
  #
  # Checks if a global variable is defined.
  #
  # Arguments:
  #   $1 Name of the variable
  #
  local variable=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  [[ "${!variable-X}" = "${!variable-Y}" ]];
}

function oi::var.has_value() {
  #
  # Checks if a value has actual value.
  #
  # Arguments:
  #   $1 Value
  #
  local value=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ -n "${value}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::var.is_empty() {
  #
  # Checks if a value is empty.
  #
  # Arguments:
  #   $1 Value
  #
  local value=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ -z "${value}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::var.equals() {
  #
  # Checks if a value equals.
  #
  # Arguments:
  #   $1 Value
  #   $2 Equals value
  #
  local value=${1};
  local equals=${2};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if [[ "${value}" = "${equals}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::var.json() {
  #
  # Creates JSON based on function arguments.
  #
  # Arguments:
  #   $@ Bash array of key/value pairs, prefix integer or boolean values with ^
  #
  local data=("$@");
  local number_of_items=${#data[@]};
  local json='';
  local separator;
  local counter;
  local item;

  if [[ ${number_of_items} -eq 0 ]]; then
    oi::log.error "Length of input array needs to be at least 2";
    return "${__OI_EXIT_NOK}";
  fi

  if [[ $((number_of_items%2)) -eq 1 ]]; then
    oi::log.error "Length of input array needs to be even (key/value pairs)";
    return "${__OI_EXIT_NOK}";
  fi

  counter=0;
  for i in "${data[@]}"; do
    item="\"$i\"";

    separator=","
    if [ $((++counter%2)) -eq 0 ]; then
      separator=":";

      if [[ "${i:0:1}" == "^" ]]; then
        item="${i:1}";
      else
        item=$(oi::var.json_string "${i}");
      fi
    fi

    json="$json$separator$item";
  done

  echo "{${json:1}}";
  return "${__OI_EXIT_OK}";
}

function oi::var.json_string() {
  #
  # Escapes a string for use in a JSON object.
  #
  # Arguments:
  #   $1 String to escape
  #
  local string="${1}";
  local json_string;

  # https://stackoverflow.com/a/50380697/12156188
  if json_string=$(echo -n "${string}" | jq -Rs .); then
    echo "${json_string}";
    return "${__OI_EXIT_OK}";
  fi

  oi::log.error "Failed to escape string";
  return "${__OI_EXIT_NOK}";
}
