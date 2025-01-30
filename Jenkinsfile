pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Ensure Jenkins checks out the correct branch
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[
                            url: 'https://github.com/ajMobileConsulting/BankMapper.git',
                            credentialsId: 'github-token' // Must match the stored credentials ID
                        ]]
                    ])
                }
            }
        }
    }
}