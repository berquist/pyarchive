#!/bin/bash

# This file is meant to be sourced by other scripts and contains constants
# that only should be defined in a single place.

set -euo pipefail
set -x

PYENV_CONDA_BASE=miniforge3-22.11.1-4

# A version of the snippet `conda init bash` injects into `~/.bashrc` that,
# although dependent on pyenv ($PYENV_ROOT), is independent of the base conda
# name.
init_conda() {
    local pyenv_conda_base="${1}"

    local conda_base="${PYENV_ROOT}/versions/${pyenv_conda_base}"
    if [[ -d "${conda_base}" ]]; then
        local __conda_setup
        __conda_setup=$("${conda_base}/bin/conda" 'shell.bash' 'hook' 2> /dev/null)
        if [[ $? -eq 0 ]]; then
            eval "${__conda_setup}"
        else
            local conda_sh_loc="${conda_base}/etc/profile.d/conda.sh"
            if [[ -f "${conda_sh_loc}" ]]; then
                . "${conda_sh_loc}"
            else
                export PATH="${conda_base}/bin:$PATH"
            fi
        fi
    fi
}

# Does the conda environment with the given name exist?
# (https://stackoverflow.com/q/70597896)
conda_env_exists() {
    conda info --envs | grep -q "${1}"
    return $?
}
