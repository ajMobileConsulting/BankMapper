pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the correct branch for PRs or normal commits
                    checkout scm
                }
            }
        }


        stage('Install Dependencies') {
            steps {
                sh 'gem install bundler danger faraday-retry'
            }
        }

        stage('Run Danger Checks') {
            when {
                expression { return env.CHANGE_ID != null } // Runs only on PRs
            }
            steps {
                sh 'bundle exec danger'
            }
        }
    }
}
