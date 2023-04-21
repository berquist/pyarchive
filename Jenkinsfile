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
                // Slightly wasteful to always have conda installed, but for
                // now it's easier than writing soup to avoid problems from
                // attempting parallel installs.
                sh './install_base_conda.sh'
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
                            sh './install_deps_venv.sh'
                        }
                    }
                    stage('InstallDepsConda') {
                        when {
                            expression { env.PYTHON_ENV_TYPE == 'conda' }
                        }
                        steps {
                            sh './install_deps_conda.sh'
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
