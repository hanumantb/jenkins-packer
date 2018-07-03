def OS = ["2008R2", "2012R2", "2016"]
def lastRun;
def Destinations = ["DEN3", "DEN4", "DEN2", "SEA1", "SEA2"]

// Set up jobs
def buildOSJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    def index = i
    def osString = OS[index]
    buildOSJobs["Build OS ${OS.getAt(index)}"] = {
        build job: 'packer-BaseOS', parameters: [
        string(name: 'OSVersion', value: osString)]
    }
}

def buildDesc = "Packer - BaseOS \\ ${OSVersion}"

pipeline {
    agent { label 'packer-node' }
    environment {
        // Packer directories
        PACKER_BUILD_DIRECTORY = "D:/PackerBuilds/"
        PACKER_EXE_PATH = "D:/Packer/packer.exe"
        PACKER_CACHE_DIR = "D:/PackerCache/"
    }
    parameters {
        choice(
            // OS Version to build.
            name: 'OSVersion',
            choices:"2008R2\n2012R2\n2016",
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
                    .\\build\\Build-BaseOS.ps1 -OSVersion $env:OSVersion -OutputDirectory $env:PACKER_BUILD_DIRECTORY
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

