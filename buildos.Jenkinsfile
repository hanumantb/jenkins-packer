def buildDesc = "Packer - BaseOS \\ {$OSVersion}"
// TODO: Try adding choices here and referencing in parameters
// TODO: Can you call a pipeline from a pipeline?


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
            choices:"2008R2\n2012R2\n2016\nALL",
            description: "Operating System Version"
        )
    }
    stages {
        stage('BaseOS') {
            steps {
                powershell '''
                    .\\Build-BaseOS.ps1 -OSVersion $env:OSVersion -OutputDirectory $env:packer_build_directory
                '''
            }
        }
    }
    post {
        success {
            powershell '''
                Write-Host "Jenkins was successful!"
            '''
            cleanWs()
        }
    }
}

