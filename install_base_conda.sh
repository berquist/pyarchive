#!/bin/sh

set -eu
set -x

. ./common.sh

"${PYENV_ROOT}"/bin/pyenv install -s "${PYENV_CONDA_BASE}"
