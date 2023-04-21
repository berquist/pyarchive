#!/bin/sh

# Install the Python version and dependencies for the "pyarchive ecosystem" in
# the provided Python environment type using pyenv
# (https://github.com/pyenv/pyenv).  It assumes that pyenv is already
# available at $PYENV_ROOT.
#
# If the environment is supposed to be conda-based, then it must have already
# been installed via some other mechanism.
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

python_version=3."${PYTHON_MINOR_VERSION}"

export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

# Install the desired Python version using pyenv and set its use for this
# shell process
# (https://github.com/pyenv/pyenv/issues/492#issuecomment-160488045).
if [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_VENV}" ]; then
    PYENV_VERSION="${python_version}"
    pyenv install -s "${PYENV_VERSION}"
elif [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_CONDA}" ]; then
    # This is the expected conda install mechanism.  You could have installed
    # it via another nefarious way, but this provides a sort of provenance to
    # show what "base" conda version you might expect.
    [ -f ./install_base_conda.sh ] || exit 1
    PYENV_VERSION="${PYENV_CONDA_BASE}"
fi
export PYENV_VERSION

# Be a good citizen and provide a nested environment for conda rather than
# using the base.
if [ "${PYTHON_ENV_TYPE}" = "${PYTHON_ENV_TYPE_CONDA}" ]; then
    # We don't `conda init` since that will modify a `~/.bashrc` that will
    # give us even less environment isolation than we already have...
    init_conda "${PYENV_CONDA_BASE}"
    conda_env_name="pyarchive-${python_version}"
    conda create -n "${conda_env_name}" python="${python_version}"
    conda activate "${conda_env_name}"
fi

python -m pip install -U pip setuptools
python -m pip config list
python -m pip install pytest-cov

unset PYENV_VERSION
