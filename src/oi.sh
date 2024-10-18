#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================
set -o errexit;  # Exit script when a command exits with non-zero status
# set -o errtrace; # Exit on error inside any functions or sub-shells
set -o nounset;  # Exit script on use of an undefined variable
set -o pipefail; # Return exit status of the last command in the pipe that failed
# ==============================================================================

# ==============================================================================
# GLOBALS
# ==============================================================================

# Stores the location of this library
# shellcheck disable=SC2296
__OI_BIN="$(readlink -f "${(%):-%x}")";
__OI_LIB_DIR=$(dirname "${__OI_BIN}");

# shellcheck source=version.sh
source "${__OI_LIB_DIR}/version.sh";

# shellcheck source=const.sh
source "${__OI_LIB_DIR}/const.sh";

# Defaults
declare __OI_LOG_LEVEL=${LOG_LEVEL:-${__OI_DEFAULT_LOG_LEVEL}};
declare __OI_LOG_FORMAT=${LOG_FORMAT:-${__OI_DEFAULT_LOG_FORMAT}};
declare __OI_LOG_TIMESTAMP=${LOG_TIMESTAMP:-${__OI_DEFAULT_LOG_TIMESTAMP}};
declare __OI_CACHE_DIR=${CACHE_DIR:-${__OI_DEFAULT_CACHE_DIR}};

# ==============================================================================
# MODULES
# ==============================================================================
source "${__OI_LIB_DIR}/color.sh";
source "${__OI_LIB_DIR}/log.sh";

source "${__OI_LIB_DIR}/fs.sh";
source "${__OI_LIB_DIR}/cache.sh";

# source "${__OI_LIB_DIR}/config.sh";  # TODO (kyle): create similar interface - https://github.com/hassio-addons/bashio/blob/main/lib/config.sh
source "${__OI_LIB_DIR}/debug.sh";
source "${__OI_LIB_DIR}/exit.sh";
# source "${__OI_LIB_DIR}/info.sh";  # TODO (kyle): create similar interface without using HASS API - https://github.com/hassio-addons/bashio/blob/main/lib/info.sh
source "${__OI_LIB_DIR}/jq.sh";
# source "${__OI_LIB_DIR}/os.sh";  # TODO (kyle): create similar interface without using HASS API - https://github.com/hassio-addons/bashio/blob/main/lib/os.sh
source "${__OI_LIB_DIR}/string.sh";
source "${__OI_LIB_DIR}/var.sh";

source "${__OI_LIB_DIR}/help.sh";
