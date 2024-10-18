#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================


function oi::log() {
  #
  # Log a message to output.
  #
  # Arguments:
  #   $1 Message to display
  #
  local message=$*;
  echo -e "${message}" >&2;
  return "${__OI_EXIT_OK}";
}

function oi::log.red() {
  #
  # Log a message to output (in red).
  #
  # Arguments:
  #   $1 Message to display
  #
  local message=$*;
  echo -e "${__OI_COLORS_RED}${message}${__OI_COLORS_RESET}" >&2;
  return "${__OI_EXIT_OK}";
}

function oi::log.green() {
  #
  # Log a message to output (in green).
  #
  # Arguments:
  #   $1 Message to display
  #
  local message=$*;
  echo -e "${__OI_COLORS_GREEN}${message}${__OI_COLORS_RESET}" >&2;
  return "${__OI_EXIT_OK}";
}

function oi::log.yellow() {
  #
  # Log a message to output (in yellow).
  #
  # Arguments:
  #   $1 Message to display
  #
  local message=$*;
  echo -e "${__OI_COLORS_YELLOW}${message}${__OI_COLORS_RESET}" >&2;
  return "${__OI_EXIT_OK}";
}

function oi::log.blue() {
  #
  # Log a message to output (in blue).
  #
  # Arguments:
  #   $1 Message to display
  #
  local message=$*;
  echo -e "${__OI_COLORS_BLUE}${message}${__OI_COLORS_RESET}" >&2;
  return "${__OI_EXIT_OK}";
}

function oi::log.magenta() {
  #
  # Log a message to output (in magenta).
  #
  # Arguments:
  #   $1 Message to display
  #
  local message=$*;
  echo -e "${__OI_COLORS_MAGENTA}${message}${__OI_COLORS_RESET}" >&2;
  return "${__OI_EXIT_OK}";
}

function oi::log.cyan() {
  #
  # Log a message to output (in cyan).
  #
  # Arguments:
  #   $1 Message to display
  #
  local message=$*;
  echo -e "${__OI_COLORS_CYAN}${message}${__OI_COLORS_RESET}" >&2;
  return "${__OI_EXIT_OK}";
}

function oi::log.log() {
  #
  # Log a message using a log level.
  #
  # Arguments:
  #   $1 Log level
  #   $2 Message to display
  #
  local level=${1};
  local message=${2};
  local timestamp;
  local output;

  if [[ "${level}" -gt "${__OI_LOG_LEVEL}" ]]; then
    return "${__OI_EXIT_OK}";
  fi

  timestamp=$(date +"${__OI_LOG_TIMESTAMP}");

  output="${__OI_LOG_FORMAT}";
  output="${output//\{TIMESTAMP\}/"${timestamp}"}";
  output="${output//\{MESSAGE\}/"${message}"}";
  output="${output//\{LEVEL\}/"${__OI_LOG_LEVELS[$level]}"}";

  echo -e "${output}" >&2;

  return "${__OI_EXIT_OK}";
}

function oi::log.trace() {
  #
  # Log a message @ trace level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_TRACE}" \
    "${__OI_COLORS_DIM_YELLOW}${message}${__OI_COLORS_RESET}";
}

function oi::log.debug() {
  #
  # Log a message @ debug level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_DEBUG}" \
    "${__OI_COLORS_DIM_GREEN}${message}${__OI_COLORS_RESET}";
}

function oi::log.deprecated() {
  #
  # Log a deprecation message @ warning level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_WARNING}" \
    "${__OI_COLORS_BOLD_YELLOW}[DEPRECATED] ${message}${__OI_COLORS_RESET}";
}

function oi::log.info() {
  #
  # Log a message @ info level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_INFO}" \
    "${__OI_COLORS_BLUE}${message}${__OI_COLORS_RESET}";
}

function oi::log.notice() {
  #
  # Log a message @ notice level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_NOTICE}" \
    "${__OI_COLORS_BOLD_MAGENTA}${message}${__OI_COLORS_RESET}";
}

function oi::log.success() {
  #
  # Log a message @ info level that is bold and green.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_INFO}" \
    "${__OI_COLORS_BOLD_GREEN}${message}${__OI_COLORS_RESET}";
}

function oi::log.warning() {
  #
  # Log a message @ warning level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_WARNING}" \
    "${__OI_COLORS_BOLD_YELLOW}${message}${__OI_COLORS_RESET}";
}

function oi::log.error() {
  #
  # Log a message @ error level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_ERROR}" \
    "${__OI_COLORS_RED}${message}${__OI_COLORS_RESET}";
}

function oi::log.fatal() {
  #
  # Log a message @ fatal level.
  #
  # Arguments:
  #   $* Message to display
  #
  local message=$*;
  oi::log.log \
    "${__OI_LOG_LEVEL_FATAL}" \
    "${__OI_COLORS_BOLD_RED}${message}${__OI_COLORS_RESET}";
}

function oi::log.level() {
  #
  # Changes the log level of OI on the fly.
  #
  # Arguments:
  #   $1 Log level
  #
  local log_level=${1};

  # Find the matching log level
  case "$(oi::string.lower "${log_level}")" in
    all)
      log_level="${__OI_LOG_LEVEL_ALL}";
      ;;
    trace)
      log_level="${__OI_LOG_LEVEL_TRACE}";
      ;;
    debug)
      log_level="${__OI_LOG_LEVEL_DEBUG}";
      ;;
    info)
      log_level="${__OI_LOG_LEVEL_INFO}";
      ;;
    notice)
      log_level="${__OI_LOG_LEVEL_NOTICE}";
      ;;
    warning)
      log_level="${__OI_LOG_LEVEL_WARNING}";
      ;;
    error)
      log_level="${__OI_LOG_LEVEL_ERROR}";
      ;;
    fatal|critical)
      log_level="${__OI_LOG_LEVEL_FATAL}";
      ;;
    off)
      log_level="${__OI_LOG_LEVEL_OFF}";
      ;;
    *)
      oi::exit.error "Unknown log_level: ${log_level}"
  esac

  export __OI_LOG_LEVEL="${log_level}";
}
