pipeline {
    agent any

    environment {
        GEM_HOME = "/var/jenkins_home/.gem/ruby/3.1.0"
        PATH = "${GEM_HOME}/bin:/usr/bin:${PATH}"
        DANGER_GITHUB_API_TOKEN = credentials('GitHub-token') // Ensure GitHub API token is used
    }

    stages {
        stage('Checkout') {
    steps {
        script {
            def branch = env.CHANGE_BRANCH ?: env.BRANCH_NAME ?: 'main'

            checkout([
                $class: 'GitSCM',
                branches: [[name: "*/${branch}"]],
                userRemoteConfigs: [[
                    url: 'https://github.com/ajMobileConsulting/BankMapper.git',
                    credentialsId: 'GitHub-token'
                ]],
                extensions: [[$class: 'PruneStaleBranch']]
            ])

            if (env.CHANGE_ID) { // Ensure PR branch is fetched correctly
                sh 'git fetch origin "+refs/pull/${CHANGE_ID}/head:pr-${CHANGE_ID}"'
                sh 'git checkout pr-${CHANGE_ID}'
            }
        }
    }
}

        stage('Install Dependencies') {
            steps {
                sh 'export PATH=$HOME/.gem/ruby/3.1.0/bin:$PATH'
                sh 'gem install --user-install bundler danger faraday-retry'
            }
        }

stage('Run Danger Checks') {
    steps {
        script {
            def prNumber = env.CHANGE_ID ?: sh(script: "git rev-parse --abbrev-ref HEAD | grep -oP '(?<=PR-)[0-9]+'", returnStdout: true).trim()

            if (prNumber) {
                withCredentials([string(credentialsId: 'GitHub-Secret-Text', variable: 'DANGER_GITHUB_API_TOKEN')]) {
                    withEnv(["DANGER_GITHUB_API_TOKEN=${env.DANGER_GITHUB_API_TOKEN}"]) {
                        sh "danger --dangerfile=Dangerfile pr https://github.com/ajMobileConsulting/BankMapper/pull/${prNumber}"
                    }
                }
            } else {
                echo "Skipping Danger since no PR number could be detected."
            }
        }
    }
}
        stage('Debug PR Detection') {
    steps {
        script {
            echo "CHANGE_ID: ${env.CHANGE_ID ?: 'Not Set'}"
            echo "CHANGE_TARGET: ${env.CHANGE_TARGET ?: 'Not Set'}"
            echo "BRANCH_NAME: ${env.BRANCH_NAME ?: 'Not Set'}"
            echo "GIT_BRANCH: ${env.GIT_BRANCH ?: 'Not Set'}"
        }
    }
}

    }
}
