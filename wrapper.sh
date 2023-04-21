#!/bin/sh

set -eux

PYTHON_ENV_TYPE="${1}"
PYTHON_MINOR_VERSION="${2}"
PACKAGE_BASE_PATH="${3}"

logname="log-${PYTHON_ENV_TYPE}-${PYTHON_MINOR_VERSION}.txt"
rm "${logname}"
for package in libstore libjournal libarchive; do
    ./install_deps_and_test.sh "${PYTHON_ENV_TYPE}" "${PYTHON_MINOR_VERSION}" "${PACKAGE_BASE_PATH}/${package}" | tee -a "${logname}"
done
