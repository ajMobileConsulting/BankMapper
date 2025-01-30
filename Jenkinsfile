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
                script {
                    def branch = env.CHANGE_BRANCH ?: env.BRANCH_NAME ?: 'main'  // Support PRs and regular builds
                    
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "*/${branch}"]],
                        userRemoteConfigs: [[
                            url: 'https://github.com/ajMobileConsulting/BankMapper.git',
                            credentialsId: 'GitHub-token'
                        ]],
                        extensions: [[$class: 'PruneStaleBranch']]
                    ])
                }
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
                    if (env.CHANGE_ID) {  // Ensure this is a PR build
                        sh 'git fetch origin "+refs/pull/*:refs/remotes/origin/pr/*"'
                        sh "danger --dangerfile=Dangerfile pr https://github.com/ajMobileConsulting/BankMapper/pull/${CHANGE_ID}"
                    } else {
                        echo "Skipping Danger since this is not a pull request."
                    }
                }
            }
        }
    }
}
