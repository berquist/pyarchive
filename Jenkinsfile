// This is an example of a pipeline that combines multiple checkouts, installs
// all dependencies, tests each repository sequentially, and runs on bare
// metal.
pipeline {
    agent any

    environment {
        PYENV_ROOT = "${env.WORKSPACE}/pyenv"
    }

    stages {
        stage('Checkout') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ericjohnberquist', keyFileVariable: '')]) {
                    dir('libstore') {
                        checkout scmGit(
                            branches: [[name: '*/master']],
                            extensions: [cleanBeforeCheckout()],
                            userRemoteConfigs: [[url: 'git@github.com:berquist/libstore.git']])
                    }
                    // libjournal depends on libstore.
                    dir('libjournal') {
                        checkout scmGit(
                            branches: [[name: '*/master']],
                            extensions: [cleanBeforeCheckout()],
                            userRemoteConfigs: [[url: 'git@github.com:berquist/libjournal.git']])
                    }
                    // libarchive depends on libjournal.
                    dir('libarchive') {
                        checkout scmGit(
                            branches: [[name: '*/master']],
                            extensions: [cleanBeforeCheckout()],
                            userRemoteConfigs: [[url: 'git@github.com:berquist/libarchive.git']])
                    }
                }

            }
        }
        stage('InstallBaseDeps') {
            steps {
                dir('pyenv') {
                    checkout scmGit(
                        branches: [[name: 'refs/tags/v2.3.17']],
                        extensions: [],
                        userRemoteConfigs: [[url: 'https://github.com/pyenv/pyenv.git']])
                }
            }
        }
        stage('InstallAndTest') {
            matrix {
                axes {
                    axis {
                        name 'PYTHON_MINOR_VERSION'
                        values '7', '8', '9', '10'
                    }
                    axis {
                        name 'PYTHON_ENV_TYPE'
                        values 'venv', 'conda'
                    }
                }
                // agent {
                //     docker { image "python:3.${PYTHON_MINOR_VERSION}" }
                // }
                stages {
                    stage('InstallDepsVenv') {
                        when {
                            expression { env.PYTHON_ENV_TYPE == 'venv' }
                        }
                        steps {
                            sh '${PYENV_ROOT}/bin/pyenv install -s 3.${PYTHON_MINOR_VERSION}'
                        }
                    }
                    stage('InstallDepsConda') {
                        when {
                            expression { env.PYTHON_ENV_TYPE == 'conda' }
                        }
                        steps {
                            sh '${PYENV_ROOT}/bin/pyenv install -s miniforge3-22.11.1-4'
                            sh '${PYENV_ROOT}/bin/pyenv activate miniforge3-22.11.1-4'
                        }
                    }
                    // stage('Test') {
                    //     steps {
                    //         // echo "Test on Python 3.${PYTHON_MINOR_VERSION} using ${ENV_TYPE}"
                    //         // sh 'pwd; ls -al'
                    //         // sh(script: 'python -m pytest -v --cov=libstore', encoding: 'UTF-8')
                    //     }
                    // }
                }
            }
        }
    }
}
