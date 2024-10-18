#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::string.lower() {
  #
  # Converts a string to lower case.
  #
  # Arguments:
  #   $1 String to convert
  #
  local string="${1}";

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  printf "%s" "${string,,}";
}

function oi::string.upper() {
  #
  # Converts a string to upper case.
  #
  # Arguments:
  #   $1 String to convert
  #
  local string="${1}";

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  printf "%s" "${string^^}";
}

function oi::string.replace() {
  #
  # Replaces parts of the string with an other string.
  #
  # Arguments:
  #   $1 String to make replacements in
  #   $2 String part to replace
  #   $3 String replacement
  #
  local string="${1}";
  local needle="${2}";
  local replacement="${3}";

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  printf "%s" "${string//${needle}/${replacement}}";
}

oi::string.length() {
  #
  # Returns the length of a string.
  #
  # Arguments:
  #   $1 String to determine the length of
  #
  local string="${1}";

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  printf "%s" "${#string}";
}

function oi::string.substring() {
  #
  # Returns a substring of a string.
  #
  #   stringZ=abcABC123ABCabc
  #   oi::string.substring "${stringZ}" 0      # abcABC123ABCabc
  #   oi::string.substring "${stringZ}" 1      # bcABC123ABCabc
  #   oi::string.substring "${stringZ}" 7      # 23ABCabc
  #   oi::string.substring "${stringZ}" 7 3    # 23AB
  #
  # Arguments:
  #   $1 String to return a substring off
  #   $2 Position to start
  #   $3 Length of the substring (optional)
  #
  local string="${1}";
  local position="${2}";
  local length="${3:-}";

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if oi::var.has_value "${length}"; then
    printf "%s" "${string:${position}:${length}}";
  else
    printf "%s" "${string:${position}}";
  fi
}
