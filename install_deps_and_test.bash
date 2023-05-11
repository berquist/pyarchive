#!/bin/bash

# Install the Python version and dependencies for the "pyarchive ecosystem" in
# the provided Python environment type using pyenv
# (https://github.com/pyenv/pyenv).  It assumes that pyenv is already
# available at $PYENV_ROOT.
#
# If the environment is supposed to be conda-based, then it must have already
# been installed via some other mechanism.
set -euo pipefail
set -x

PYTHON_ENV_TYPE_CONDA="conda"
PYTHON_ENV_TYPE_VENV="venv"

. ./common.bash

# must be one of "conda" or "venv"
PYTHON_ENV_TYPE="${1}"
# can be either just the minor version ("11") or include the patch ("11.3")
PYTHON_MINOR_VERSION="${2}"
# absolute path to the Python package being installed; assume the last
# component (basename) is the Python package name
PACKAGE_PATH="${3}"

if [[ "${PYTHON_ENV_TYPE}" != "${PYTHON_ENV_TYPE_CONDA}" ]] \
       && [[ "${PYTHON_ENV_TYPE}" != "${PYTHON_ENV_TYPE_VENV}" ]]; then
    echo "PYTHON_ENV_TYPE (arg 1) must be \"${PYTHON_ENV_TYPE_CONDA}\" or \"${PYTHON_ENV_TYPE_VENV}\"," >&2
    echo "not \"${PYTHON_ENV_TYPE}\"" >&2
    exit 1
fi

python_version=3."${PYTHON_MINOR_VERSION}"

export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

# Install the desired Python version using pyenv and set its use for this
# shell process
# (https://github.com/pyenv/pyenv/issues/492#issuecomment-160488045).
if [[ "${PYTHON_ENV_TYPE}" == "${PYTHON_ENV_TYPE_VENV}" ]]; then
    PYENV_VERSION="${python_version}"
    pyenv install -s "${PYENV_VERSION}"
elif [[ "${PYTHON_ENV_TYPE}" == "${PYTHON_ENV_TYPE_CONDA}" ]]; then
    # This is the expected conda install mechanism.  You could have installed
    # it via another nefarious way, but this provides a sort of provenance to
    # show what "base" conda version you might expect.
    [[ -f ./install_base_conda.sh ]] || exit 1
    PYENV_VERSION="${PYENV_CONDA_BASE}"
fi
export PYENV_VERSION

# Be a good citizen and provide a nested environment for conda rather than
# using the base.
if [[ "${PYTHON_ENV_TYPE}" == "${PYTHON_ENV_TYPE_CONDA}" ]]; then
    # For some consistency, do not allow a user-provided conda config.
    export CONDARC="${PWD}/.condarc"
    # We don't `conda init` since that will modify a `~/.bashrc` that will
    # give us even less environment isolation than we already have...
    # set +e; (set -e; init_conda "${PYENV_CONDA_BASE}"); err_status=$?; set -e; [ $err_status -eq 0 ] || exit $err_status
    #
    # TODO the above catches errors thrown by internal conda functions.  It is
    # unlikely there is anything wrong with *our* function, but is it ok to
    # skip out on checking it?
    init_conda "${PYENV_CONDA_BASE}"
    conda_env_name="pyarchive-${python_version}"
    if ! conda_env_exists "${conda_env_name}"; then
        conda create -y -n "${conda_env_name}" python="${python_version}"
    fi
    conda activate "${conda_env_name}"
fi

python -m pip install -U pip setuptools
# This will not print anything if no configuration settings have been
# overridden, which is the case by default.
python -m pip config list
python -m pip install pytest-cov

install_and_test_package() {
    local _PACKAGE_PATH="${1}"

    local package_name
    package_name=$(basename "${_PACKAGE_PATH}")

    # Finally install the package.  Avoid concurrent process race conditions
    # by not using a generic (wheel) build location.
    python -m pip wheel \
           --build-option="--bdist-dir=\"${_PACKAGE_PATH}/build_${PYTHON_ENV_TYPE}_${python_version}\"" \
           -w "${_PACKAGE_PATH}/wheels" \
           "${_PACKAGE_PATH}"
    python -m pip install "${_PACKAGE_PATH}/wheels/*.whl"
    local PACKAGE_INSTALL_DIR
    PACKAGE_INSTALL_DIR=$(python -c "import ${package_name} as _; print(_.__path__[0])")
    find "${PACKAGE_INSTALL_DIR}" -type f | sort
    # h5py installation style depends on the env type.
    # TODO why is this after package installation?
    case "${PYTHON_ENV_TYPE}" in
        "${PYTHON_ENV_TYPE_CONDA}")
            conda install h5py
            ;;
        "${PYTHON_ENV_TYPE_VENV}")
            python -m pip install h5py
            ;;
    esac

    python -m pip list
    if [[ "${PYTHON_ENV_TYPE}" == "${PYTHON_ENV_TYPE_CONDA}" ]]; then
        conda list
        conda info
        conda config --show
    fi

    # Testing the installed package requires moving out of the source directory.
    # There are problems with the pytest cache when trying to run from a
    # non-writable dir.
    cd "${HOME}"
    python -m pytest -v --cov="${package_name}" --cov-report=xml "${PACKAGE_INSTALL_DIR}"
}

set +e; (set -e; install_and_test_package "${PACKAGE_PATH}"); err_status=$?; set -e; [ $err_status -eq 0 ] || exit $err_status

# TODO unset CONDARC
unset PYENV_VERSION
