#!/bin/bash

set -euo pipefail
set -x

. ./common.bash

"${PYENV_ROOT}"/bin/pyenv install -s "${PYENV_CONDA_BASE}"
