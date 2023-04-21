#!/bin/sh

set -eu

"${PYENV_ROOT}"/bin/pyenv install -s 3."${PYTHON_MINOR_VERSION}"
"${PYENV_ROOT}"/bin/pyenv shell 3."${PYTHON_MINOR_VERSION}"
python -m pip install -U pip setuptools
python -m pip config list
python -m pip install pytest-cov
