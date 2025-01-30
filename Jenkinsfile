pipeline {
    agent any

    environment {
        GEM_HOME = "${HOME}/.gem/ruby/3.1.0"
        PATH = "${GEM_HOME}/bin:${PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        userRemoteConfigs: [[
                            url: 'https://github.com/ajMobileConsulting/BankMapper.git',
                            credentialsId: 'GitHub-token'
                        ]]
                    ])
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'gem install --user-install bundler danger faraday-retry'
                sh 'export PATH="$HOME/.gem/ruby/3.1.0/bin:$PATH"'
            }
        }

        stage('Run Danger Checks') {
            steps {
                sh 'danger --dangerfile=Dangerfile pr'  // Ensure it runs on PRs
            }
        }
    }
}
