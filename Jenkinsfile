pipeline {
    agent {
        node {
            label 'master'
        }
    }
environment {
        TERRAFORM_CMD = 'docker run --network host " -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app hashicorp/terraform:light'
    }
    stages {
        stage('checkout repo') {
            steps {
              git branch: 'my_specific_branch',
                url: 'https://github.com/vynu/terraform-jenkins.git'

              sh "ls -lat"
            }
        }
}
