pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ericjohnberquist', keyFileVariable: '')]) {
                    dir('libstore') {
                        git 'git@github.com:berquist/libstore.git'
                    }
                    dir('libjournal') {
                        git 'git@github.com:berquist/libjournal.git'
                    }
                    dir('libarchive') {
                        git 'git@github.com:berquist/libarchive.git'
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
