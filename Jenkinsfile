pipeline {
    agent any

    stages {
        stage('Build') {
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

        stage('Test') {
            steps {
                sh 'pwd; ls -al'
                // sh(script: 'python -m pytest -v --cov=libstore', encoding: 'UTF-8')
            }
        }
    }
}
