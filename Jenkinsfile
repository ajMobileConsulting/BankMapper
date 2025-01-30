pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
        git branch: 'main', url: 'https://github.com/ajMobileConsulting/BankMapper.git'
            }
        }

        stage('Build iOS App') {
            steps {
                sh '''
                xcodebuild clean build \
                -scheme BankMapper \
                -destination "platform=iOS Simulator,name=iPhone 14,OS=latest"
                '''
            }
        }

        stage('Run Danger Checks') {
            steps {
                sh 'bundle exec danger'
            }
        }
    }
}
