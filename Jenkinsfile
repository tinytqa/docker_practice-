pipeline {
    agent any

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
                echo 'Restoring TestDocker.sln'
                bat 'dotnet restore TestDocker/TestDocker.sln'
            }
        }

        stage('Build Project') {
            steps {
                echo 'Building project in Release mode'
                bat 'dotnet build TestDocker/TestDocker.sln --configuration Release'
            }
        }

        stage('Publish to Folder') {
            steps {
                echo 'Publishing to local ./publish folder'
                bat 'dotnet publish TestDocker/TestDocker.sln -c Release -o ./publish'
            }
        }
        stage('Check DLL name') {
            steps {
                bat 'dir /b publish\\*.dll'
            }
        }


        stage('Copy to IIS Folder') {
            steps {
                echo 'Copying published files to IIS folder'
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
                echo 'Building Docker image p27625:latest'
                bat 'docker build -t p27625:latest "%WORKSPACE%"'
            }
        }

        stage('Run Docker Container') {
            steps {
                echo 'Running Docker container from image p27625:latest'
                // Xoá container cũ nếu tồn tại để tránh lỗi name already in use
                bat '''
                    docker rm -f p27625run || echo "No existing container"
                    docker run -d --name p27625run -p 91:80 p27625:latest
                '''
            }
        }
        pipeline {
    agent any  // Jenkins agent sử dụng để thực hiện các bước

    environment {
        // Cấu hình Docker Hub Credentials (ID bạn đã tạo ở bước trước)
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        IMAGE_NAME = 'myusername/my-app'  // Tên image trên Docker Hub
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout mã nguồn từ GitHub hoặc repository của bạn
                git 'https://github.com/your-username/your-repository.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image từ Dockerfile
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Đăng nhập vào Docker Hub để push image
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        // Đăng nhập với Docker Hub credentials
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Đẩy Docker image lên Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                // Dọn dẹp các image Docker không cần thiết sau khi push
                sh 'docker rmi ${IMAGE_NAME}:latest'
            }
        }
    }

    post {
        success {
            echo 'Docker image đã được đẩy lên Docker Hub thành công!'
        }
        failure {
            echo 'Pipeline thất bại!'
        }
    }
}
   
    }
}
