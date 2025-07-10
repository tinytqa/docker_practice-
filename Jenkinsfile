pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials' // ID credential Jenkins đã cấu hình
        IMAGE_NAME = 'yourdockerhubusername/testdockerapp' // Đổi thành Docker Hub repo của bạn
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/tinytqa/docker_practice-'
            }
        }

        stage('List Files') {
            steps {
                bat 'dir /s /b'
            }
        }

        stage('Restore Package') {
            steps {
                echo 'Restoring packages'
                bat 'dotnet restore TestDocker/TestDocker.sln'
            }
        }

        stage('Build Project') {
            steps {
                echo 'Building project in Release mode'
                bat 'dotnet build TestDocker/TestDocker.sln --configuration Release'
            }
        }

        stage('Publish') {
            steps {
                echo 'Publishing project'
                bat 'dotnet publish TestDocker/TestDocker.sln -c Release -o ./publish'
            }
        }

        stage('Check DLL') {
            steps {
                bat 'dir /b publish\\*.dll'
            }
        }

        stage('Copy to IIS') {
            steps {
                echo 'Copying to IIS folder'
                bat 'xcopy "%WORKSPACE%\\publish\\*" "C:\\wwwroot\\myproject\\" /E /Y /I /R'
            }
        }

        stage('Deploy to IIS') {
            steps {
                powershell '''
                    Import-Module WebAdministration
                    if (-not (Test-Path IIS:\\Sites\\MyDockerSite)) {
                        New-Website -Name "MyDockerSite" -Port 81 -PhysicalPath "C:\\wwwroot\\myproject"
                    } else {
                        Write-Host "Website MyDockerSite already exists."
                    }
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image'
                bat 'docker build -t %IMAGE_NAME%:latest "%WORKSPACE%"'
            }
        }

        stage('Run Docker Container Locally') {
            steps {
                echo 'Running Docker container'
                bat '''
                    docker rm -f p27625run || echo "No existing container"
                    docker run -d --name p27625run -p 91:80 %IMAGE_NAME%:latest
                '''
            }
        }

        stage('Login & Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker_credential1') {
    docker.image("${IMAGE_NAME}:latest").push()
}
                }
            }
        }

        stage('Cleanup') {
            steps {
                bat 'docker rmi %IMAGE_NAME%:latest || echo "Image not found"'
            }
        }
    }

    post {
        success {
            echo '✅ Docker image đã được build và push thành công!'
        }
        failure {
            echo '❌ Có lỗi xảy ra trong pipeline!'
        }
    }
}
