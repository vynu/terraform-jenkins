pipeline {
    agent any
environment {
        TERRAFORM_CMD = 'test'
    }
    stages {
        stage('checkout repo') {
            steps {
              git branch: 'master',
                url: 'https://github.com/vynu/terraform-jenkins.git'

              sh "ls -lat"
            }
        }
}
