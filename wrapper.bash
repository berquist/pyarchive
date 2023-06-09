#!/bin/bash

# A simple wrapper that handles installing and testing the packages of
# interest in the correct order.

set -euo pipefail
set -x

PYTHON_ENV_TYPE="${1}"
PYTHON_MINOR_VERSION="${2}"
PACKAGE_BASE_PATH="${3}"

logname="log-${PYTHON_ENV_TYPE}-${PYTHON_MINOR_VERSION}.txt"
rm "${logname}" || tmp=$?
# order matters!
# libarchive has been removed as long as it is broken
# something else is wrong with libjournal
for package in libstore; do
    set +e
    (
        set -e
        ./install_deps_and_test.bash "${PYTHON_ENV_TYPE}" "${PYTHON_MINOR_VERSION}" "${PACKAGE_BASE_PATH}/${package}" | tee -a "${logname}"
    )
    err_status=$?
    set -e
    [[ $err_status -eq 0 ]] || exit $err_status
done
