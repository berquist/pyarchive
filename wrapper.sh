#!/bin/sh

# A simple wrapper that handles installing and testing the packages of
# interest in the correct order.

set -eux

PYTHON_ENV_TYPE="${1}"
PYTHON_MINOR_VERSION="${2}"
PACKAGE_BASE_PATH="${3}"

logname="log-${PYTHON_ENV_TYPE}-${PYTHON_MINOR_VERSION}.txt"
rm "${logname}" || tmp=$?
# order matters!
# libarchive has been removed as long as it is broken
for package in libstore libjournal; do
    ./install_deps_and_test.sh "${PYTHON_ENV_TYPE}" "${PYTHON_MINOR_VERSION}" "${PACKAGE_BASE_PATH}/${package}" | tee -a "${logname}"
done