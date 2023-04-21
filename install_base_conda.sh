#!/bin/sh

set -eux

. ./common.sh

"${PYENV_ROOT}"/bin/pyenv install -s "${PYENV_CONDA_BASE}"
