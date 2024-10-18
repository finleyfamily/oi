#! ./src/oi
# shellcheck shell=bash
# ==============================================================================
# Build distributable archive.
# ==============================================================================
set -o errexit;  # Exit script when a command exits with non-zero status
set -o nounset;  # Exit script on use of an undefined variable
set -o pipefail; # Return exit status of the last command in the pipe that failed
# ==============================================================================

readonly OUT_DIR="${PWD}/dist";
readonly TMP_DIR="${PWD}/tmp/build/oi";

FILE_NAME="oi";
VERSION="";

function build::cleanup {
  #
  # Cleanup temporary files after a build has completed.
  #
  m -rf "$(dirname "${TMP_DIR}")";
}

function build::prep {
  #
  # Prepare to build archives.
  #
  rm -rf "${OUT_DIR}" "$(dirname "${TMP_DIR}")";

  mkdir -p "${OUT_DIR}";
  mkdir -p "${TMP_DIR}";

  cp -a "${PWD}/src/." "${TMP_DIR}";
}

function build::set-version {
  #
  # Generate the version file..
  #
  # Arguments:
  #   $1 Version to use.
  #
  local version="${1}";

  if [[ -z "${version}" ]]; then
    version="0.0.0";
  fi

  oi::log.info "setting version as ${version}...";

  printf '#! /usr/bin/env zsh\n# shellcheck shell=bash\nreadonly OI_VERSION="%s";\nexport OI_VERSION;\n' "${version}" > "${TMP_DIR}/version.sh";
}

function build::tar {
  #
  # Build tarball.
  #
  # Arguments:
  #   $1 Name of the archive file without extension.
  #
  local extension="tar.gz";
  local file_name="${1}";
  local out_file="${OUT_DIR}/${file_name}.${extension}";

  oi::log.info "creating tarball..."

  touch "${out_file}";

  pushd "$(dirname "${TMP_DIR}")";
  tar --exclude="\*/.\*" -czvf "${out_file}" ./;  # cspell:ignore czvf
  popd;

  oi::log.success "created ${out_file}";
}

function build::zip {
  #
  # Build zip archive.
  #
  # Arguments:
  #   $1 Name of the archive file without extension.
  #
  local extension="zip";
  local file_name="${1}";
  local out_file="${OUT_DIR}/${file_name}.${extension}";

  oi::log.info "creating zip archive..."

  pushd "$(dirname "${TMP_DIR}")";
  zip -r "${out_file}" ".";
  popd;

  oi::log.success "created ${out_file}";
}

while [[ "${1:-}" != "" ]]; do
  case $1 in
    *)
      VERSION="${1}";
      shift;
      ;;
  esac
done

if [[ -n "${VERSION}" ]]; then
  FILE_NAME="${FILE_NAME}-${VERSION}";
fi

build::prep;
build::set-version "${VERSION}";
build::tar "${FILE_NAME}";
build::zip "${FILE_NAME}";

oi::log.success "build completed! distribution artifacts can be found in ${OUT_DIR}"
