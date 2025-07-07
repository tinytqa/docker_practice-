pipeline {
    agent any
    stages {
        stage('clone') {
            steps {
                git branch: 'main', url: 'https://github.com/tinytqa/docker_practice-'
            }
        }

        /* Tùy chọn: in cây thư mục để kiểm tra */
        stage('list files') {
            steps {
                bat 'dir /s /b'
            }
        }

        stage('restore package') {
            steps {
                echo 'Restore TestDocker.sln'
                // CHỈNH LẠI ĐƯỜNG DẪN .sln ĐÚNG VỚI REPO
                bat 'dotnet restore TestDocker/TestDocker.sln'
            }
        }

        /* Thêm build / test nếu cần */
        // stage('build') {
        //     steps { bat 'dotnet build TestDocker/TestDocker.sln --configuration Release' }
        // }
    }
}
