#!/bin/sh

set -eu

. ./common.sh

"${PYENV_ROOT}"/bin/pyenv install -s "${PYENV_CONDA_BASE}"
