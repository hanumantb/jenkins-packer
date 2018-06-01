def buildDesc = "Packer - Updates \\ ${OSVersion}"

pipeline {
    agent { label 'packer' }
    environment {
        // Packer directories
        packer_build_directory = "D:/PackerBuilds/"
        packer_exe_path = "D:/Packer/packer.exe"
        // Sets permanent cache location for downloaded isos
        PACKER_CACHE_DIR = "D:/PackerCache/"
    }
    parameters {
        choice(
            // OS Version to build.
            name: 'OSVersion',
            choices:"2008R2\n2012R2\n20116",
            description: "Operating System Version"
        )
    }
    stages {
        stage('Set Description') {
            steps {
                script {
                    currentBuild.description = "${buildDesc}"
                }
            }
        }
        stage('BaseOS') {
            steps {
                powershell '''
                    .\\update\\Build-Updates.ps1 -OSVersion $env:OSVersion -OutputDirectory $env:packer_build_directory
                '''
            }
        }
    }
    post {
        success {
            powershell '''
                Write-Host "Jenkins was successful!"
            '''
            // cleanWs()
        }
    }
}

