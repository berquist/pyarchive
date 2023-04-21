#!/bin/sh

set -eu

"${PYENV_ROOT}"/bin/pyenv init
"${PYENV_ROOT}"/bin/pyenv shell miniforge3-22.11.1-4
# python -m pip install -U pip setuptools
# python -m pip config list
# python -m pip install pytest-cov
