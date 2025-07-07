pipeline {
    agent any 
    stages {
        stage ('clone') {
            steps {
                git branch: 'main', url: 'https://github.com/tinytqa/docker_practice-'
            }
        }
        stage('restore package') {
            steps {
                echo 'Restore TestDocker.sln'
                bat 'dotnet restore TestDocker.sln'
            }
        }
    }
}
