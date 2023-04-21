#!/bin/sh

set -eux

PYTHON_ENV_TYPE_CONDA="conda"
PYTHON_ENV_TYPE_VENV="venv"

. ./common.sh

# must be one of "conda" or "venv"
PYTHON_ENV_TYPE="${1}"
# can be either just the minor version ("11") or include the patch ("11.3")
PYTHON_MINOR_VERSION="${2}"

if [ "${PYTHON_ENV_TYPE}" != "${PYTHON_ENV_TYPE_CONDA}" ] \
       && [ "${PYTHON_ENV_TYPE}" != "${PYTHON_ENV_TYPE_VENV}" ]; then
    echo "PYTHON_ENV_TYPE (arg 1) must be \"${PYTHON_ENV_TYPE_CONDA}\" or \"${PYTHON_ENV_TYPE_VENV}\"," >&2
    echo "not \"${PYTHON_ENV_TYPE}\"" >&2
    exit 1
fi

# Install the desired Python version using pyenv.  If the environment is
# supposed to be conda-based, then it must have already been installed via
# some other mechanism..
if [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_VENV}" ]; then
    PYENV_VERSION=3."${PYTHON_MINOR_VERSION}"
    "${PYENV_ROOT}"/bin/pyenv install -s "${PYENV_VERSION}"
elif [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_CONDA}" ]; then
    # This is the expected install mechanism.  You could have installed it via
    # another nefarious way, but this provides a sort of provenance to show
    # what "base" conda version you might expect.
    [ -f ./install_base_conda.sh ] || exit 1
    PYENV_VERSION="${PYENV_CONDA_BASE}"
fi
export PYENV_VERSION

if [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_CONDA}" ]; then
    command -v conda
fi
# python -m pip install -U pip setuptools
# python -m pip config list
# python -m pip install pytest-cov

unset PYENV_VERSION
