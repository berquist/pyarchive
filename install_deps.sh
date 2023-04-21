#!/bin/sh

set -eu

PYTHON_ENV_TYPE_CONDA="conda"
PYTHON_ENV_TYPE_VENV="venv"

. ./common.sh

# must be one of "conda" or "venv"
PYTHON_ENV_TYPE="${1}"
# can be either just the minor version ("11") or include the patch ("11.3")
PYTHON_MINOR_VERSION="${2}"

if [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_VENV}" ]; then
    PYENV_VERSION=3."${PYTHON_MINOR_VERSION}"
    "${PYENV_ROOT}"/bin/pyenv install -s "${PYENV_VERSION}"
elif [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_CONDA}" ]; then
    PYENV_VERSION="${PYENV_CONDA_BASE}"
fi
export PYENV_VERSION

# "${PYENV_ROOT}"/bin/pyenv init
# if [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_VENV}" ]; then
#     "${PYENV_ROOT}"/bin/pyenv shell 3."${PYTHON_MINOR_VERSION}"
# elif [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_CONDA}" ]; then
#     "${PYENV_ROOT}"/bin/pyenv shell miniforge3-22.11.1-4
# fi
# python -m pip install -U pip setuptools
python -m pip config list
# python -m pip install pytest-cov

unset PYENV_VERSION
