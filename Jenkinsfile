pipeline {
    agent any

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
                    dir('libjournal') {
                        checkout scmGit(
                            branches: [[name: '*/master']],
                            extensions: [cleanBeforeCheckout()],
                            userRemoteConfigs: [[url: 'git@github.com:berquist/libjournal.git']])
                    }
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
            environment {
                PYENV_ROOT = "${env.WORKSPACE}/pyenv"
            }
            steps {
                dir('pyenv') {
                    checkout scmGit(
                        branches: [[name: 'refs/tags/v2.3.17']],
                        extensions: [],
                        userRemoteConfigs: [[url: 'https://github.com/pyenv/pyenv.git']])
                }
                sh 'realpath $PYENV_ROOT'
                sh 'ls $PYENV_ROOT'
            }
        }
        // stage('InstallAndTest') {
        //     matrix {
        //         axes {
        //             axis {
        //                 name 'PYTHON_MINOR_VERSION'
        //                 values '7', '8', '9', '10'
        //             }
        //             // axis {
        //             //     name 'ENV_TYPE'
        //             //     values 'venv', 'conda'
        //             // }
        //         }
        //         // agent {
        //         //     docker { image "python:3.${PYTHON_MINOR_VERSION}" }
        //         // }
        //         stages {
        //             // stage('InstallDeps') {
        //             //     steps {

        //             //     }
        //             // }
        //             stage('Test') {
        //                 steps {
        //                     // echo "Test on Python 3.${PYTHON_MINOR_VERSION} using ${ENV_TYPE}"
        //                     // sh 'pwd; ls -al'
        //                     // sh(script: 'python -m pytest -v --cov=libstore', encoding: 'UTF-8')
        //                 }
        //             }
        //         }
        //     }
        // }
    }
}
