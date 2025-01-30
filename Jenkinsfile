pipeline {
    agent any

    environment {
        GEM_HOME = "${HOME}/.gem/ruby/3.1.0"
        PATH = "${GEM_HOME}/bin:${PATH}"
        DANGER_GITHUB_API_TOKEN = credentials('GitHub-token') // Ensure GitHub API token is used
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/${BRANCH_NAME}']],  // Ensure it checks out PR branches
                    userRemoteConfigs: [[
                        url: 'https://github.com/ajMobileConsulting/BankMapper.git',
                        credentialsId: 'GitHub-token'
                    ]]
                ])
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'gem install --user-install bundler danger faraday-retry'
            }
        }

        stage('Run Danger Checks') {
            steps {
                script {
                    def pr_number = sh(script: "git branch --contains HEAD | grep -o '[0-9]*' || echo ''", returnStdout: true).trim()
                    if (pr_number) {
                        sh "danger --dangerfile=Dangerfile pr https://github.com/ajMobileConsulting/BankMapper/pull/${pr_number}"
                    } else {
                        error "No pull request found for this branch"
                    }
                }
            }
        }
    }
}
