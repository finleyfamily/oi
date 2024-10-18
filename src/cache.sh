#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::cache.exists() {
  #
  # Check if a cache key exists in the cache
  #
  # Arguments:
  #   $1 Cache key
  #
  local key=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if oi::fs.file_exists "${__OI_CACHE_DIR}/${key}.cache"; then
    return "${__OI_EXIT_OK}";
  fi

  return "${__OI_EXIT_NOK}";
}

function oi::cache.get() {
  #
  # Returns the cached value based on a key
  #
  # Arguments:
  #   $1 Cache key
  #
  local key=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if ! oi::cache.exists "${key}"; then
    return "${__OI_EXIT_NOK}";
  fi

  printf "%s" "$(<"${__OI_CACHE_DIR}/${key}.cache")";
  return "${__OI_EXIT_OK}";
}

function oi::cache.set() {
  #
  # Cache a value identified by a given key
  #
  # Arguments:
  #   $1 Cache key
  #   $2 Cache value
  #
  local key=${1};
  local value=${2};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if ! oi::fs.directory_exists "${__OI_CACHE_DIR}"; then
    mkdir -p "${__OI_CACHE_DIR}" ||
      oi::exit.error "Could not create cache folder";
  fi

  if ! printf "%s" "$value" > "${__OI_CACHE_DIR}/${key}.cache"; then
    oi::log.warning "An error occurred while storing ${key} to cache";
    return "${__OI_EXIT_NOK}";
  fi

  return "${__OI_EXIT_OK}";
}

function oi::cache.flush() {
  #
  # Remove a specific item from the cache based on the caching key
  #
  # Arguments:
  #   $1 Cache key
  #
  local key=${1};

  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}:" "$@";

  if ! rm -f "${__OI_CACHE_DIR}/${key}.cache"; then
    oi::exit.error "An error while flushing ${key} from cache";
    return "${__OI_EXIT_NOK}";
  fi

  return "${__OI_EXIT_OK}";
}

function oi::cache.flush_all() {
  #
  # Flush all cached data
  #
  # shellcheck disable=SC2145,SC2154
  oi::log.trace "${funcstack[@]:0:1}";

  if ! oi::fs.directory_exists "${__OI_CACHE_DIR}"; then
    return "${__OI_EXIT_OK}";
  fi

  if ! rm -f -r "${__OI_CACHE_DIR}"; then
    oi::exit.error "Could not flush cache";
    return "${__OI_EXIT_NOK}";
  fi

  return "${__OI_EXIT_OK}";
}
