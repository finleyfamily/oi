#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================
set -o errexit;  # Exit script when a command exits with non-zero status
# set -o errtrace; # Exit on error inside any functions or sub-shells
set -o nounset;  # Exit script on use of an undefined variable
set -o pipefail; # Return exit status of the last command in the pipe that failed
# ==============================================================================

# Defaults
readonly __OI_DEFAULT_CACHE_DIR="/tmp/.oi";
readonly __OI_DEFAULT_LOG_LEVEL=5;  # Defaults to INFO
readonly __OI_DEFAULT_LOG_TIMESTAMP="%T";

# Exit codes
readonly __OI_EXIT_OK=0;  # Successful termination
readonly __OI_EXIT_NOK=1; # Termination with errors

# Colors
readonly __OI_COLORS_ESCAPE="\033[";
readonly __OI_COLORS_RESET="${__OI_COLORS_ESCAPE}0m";

readonly __OI_COLORS_DEFAULT="${__OI_COLORS_ESCAPE}39m";
readonly __OI_COLORS_BLACK="${__OI_COLORS_ESCAPE}30m";
readonly __OI_COLORS_RED="${__OI_COLORS_ESCAPE}31m";
readonly __OI_COLORS_GREEN="${__OI_COLORS_ESCAPE}32m";
readonly __OI_COLORS_YELLOW="${__OI_COLORS_ESCAPE}33m";
readonly __OI_COLORS_BLUE="${__OI_COLORS_ESCAPE}34m";
readonly __OI_COLORS_MAGENTA="${__OI_COLORS_ESCAPE}35m";
readonly __OI_COLORS_CYAN="${__OI_COLORS_ESCAPE}36m";
readonly __OI_COLORS_LIGHT_GRAY="${__OI_COLORS_ESCAPE}37m";

readonly __OI_COLORS_BG_DEFAULT="${__OI_COLORS_ESCAPE}49m";
readonly __OI_COLORS_BG_BLACK="${__OI_COLORS_ESCAPE}40m";
readonly __OI_COLORS_BG_RED="${__OI_COLORS_ESCAPE}41m";
readonly __OI_COLORS_BG_GREEN="${__OI_COLORS_ESCAPE}42m";
readonly __OI_COLORS_BG_YELLOW="${__OI_COLORS_ESCAPE}43m";
readonly __OI_COLORS_BG_BLUE="${__OI_COLORS_ESCAPE}44m";
readonly __OI_COLORS_BG_MAGENTA="${__OI_COLORS_ESCAPE}45m";
readonly __OI_COLORS_BG_CYAN="${__OI_COLORS_ESCAPE}46m";
readonly __OI_COLORS_BG_WHITE="${__OI_COLORS_ESCAPE}47m";

readonly __OI_COLORS_BOLD_DEFAULT="${__OI_COLORS_ESCAPE}39;1m";
readonly __OI_COLORS_BOLD_BLACK="${__OI_COLORS_ESCAPE}30;1m";
readonly __OI_COLORS_BOLD_RED="${__OI_COLORS_ESCAPE}31;1m";
readonly __OI_COLORS_BOLD_GREEN="${__OI_COLORS_ESCAPE}32;1m";
readonly __OI_COLORS_BOLD_YELLOW="${__OI_COLORS_ESCAPE}33;1m";
readonly __OI_COLORS_BOLD_BLUE="${__OI_COLORS_ESCAPE}34;1m";
readonly __OI_COLORS_BOLD_MAGENTA="${__OI_COLORS_ESCAPE}35;1m";
readonly __OI_COLORS_BOLD_CYAN="${__OI_COLORS_ESCAPE}36;1m";
readonly __OI_COLORS_BOLD_LIGHT_GRAY="${__OI_COLORS_ESCAPE}37;1m";

readonly __OI_COLORS_DIM_DEFAULT="${__OI_COLORS_ESCAPE}39;2m";
readonly __OI_COLORS_DIM_BLACK="${__OI_COLORS_ESCAPE}30;2m";
readonly __OI_COLORS_DIM_RED="${__OI_COLORS_ESCAPE}31;2m";
readonly __OI_COLORS_DIM_GREEN="${__OI_COLORS_ESCAPE}32;2m";
readonly __OI_COLORS_DIM_YELLOW="${__OI_COLORS_ESCAPE}33;2m";
readonly __OI_COLORS_DIM_BLUE="${__OI_COLORS_ESCAPE}34;2m";
readonly __OI_COLORS_DIM_MAGENTA="${__OI_COLORS_ESCAPE}35;2m";
readonly __OI_COLORS_DIM_CYAN="${__OI_COLORS_ESCAPE}36;2m";
readonly __OI_COLORS_DIM_LIGHT_GRAY="${__OI_COLORS_ESCAPE}37;2m";

readonly __OI_COLORS_ITALIC_DEFAULT="${__OI_COLORS_ESCAPE}39;3m";
readonly __OI_COLORS_ITALIC_BLACK="${__OI_COLORS_ESCAPE}30;3m";
readonly __OI_COLORS_ITALIC_RED="${__OI_COLORS_ESCAPE}31;3m";
readonly __OI_COLORS_ITALIC_GREEN="${__OI_COLORS_ESCAPE}32;3m";
readonly __OI_COLORS_ITALIC_YELLOW="${__OI_COLORS_ESCAPE}33;3m";
readonly __OI_COLORS_ITALIC_BLUE="${__OI_COLORS_ESCAPE}34;3m";
readonly __OI_COLORS_ITALIC_MAGENTA="${__OI_COLORS_ESCAPE}35;3m";
readonly __OI_COLORS_ITALIC_CYAN="${__OI_COLORS_ESCAPE}36;3m";
readonly __OI_COLORS_ITALIC_LIGHT_GRAY="${__OI_COLORS_ESCAPE}37;3m";

# Log levels
readonly __OI_LOG_LEVEL_ALL=8;
readonly __OI_LOG_LEVEL_DEBUG=6;
readonly __OI_LOG_LEVEL_ERROR=2;
readonly __OI_LOG_LEVEL_FATAL=1;
readonly __OI_LOG_LEVEL_INFO=5;
readonly __OI_LOG_LEVEL_NOTICE=4;
readonly __OI_LOG_LEVEL_OFF=0;
readonly __OI_LOG_LEVEL_TRACE=7;
readonly __OI_LOG_LEVEL_WARNING=3;
# shellcheck disable=SC2004
readonly -A __OI_LOG_LEVELS=(
  [${__OI_LOG_LEVEL_OFF}]="OFF"
  [${__OI_LOG_LEVEL_FATAL}]="FATAL"
  [${__OI_LOG_LEVEL_ERROR}]="ERROR"
  [${__OI_LOG_LEVEL_WARNING}]="WARNING"
  [${__OI_LOG_LEVEL_NOTICE}]="NOTICE"
  [${__OI_LOG_LEVEL_INFO}]="INFO"
  [${__OI_LOG_LEVEL_DEBUG}]="DEBUG"
  [${__OI_LOG_LEVEL_TRACE}]="TRACE"
  [${__OI_LOG_LEVEL_ALL}]="ALL"
)

# Log format
readonly __OI_DEFAULT_LOG_FORMAT="${__OI_COLORS_DIM_CYAN}[{TIMESTAMP}]${__OI_COLORS_RESET} ${__OI_COLORS_ESCAPE}1m{LEVEL}:${__OI_COLORS_RESET} {MESSAGE}";
