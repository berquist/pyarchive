#!/bin/sh

set -eu

"${PYENV_ROOT}"/bin/pyenv install -s 3."${PYTHON_MINOR_VERSION}"
