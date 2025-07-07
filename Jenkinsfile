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
        // dua vao docker image
		stage('docker image') {
            steps {
                 bat '''
					  docker build -t p27625:lastest -f "%WORKSPACE%\\Dockerfile" .
					'''
                }
            }

		// dua vao docker image
		stage('docker run') {
            steps {
                  bat 'docker run -d --name p27625run -p 91:80 p27625:lastest'
                }
            }


    }
}
