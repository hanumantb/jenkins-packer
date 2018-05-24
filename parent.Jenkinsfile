def buildDesc = "Packer - Deploy \\ Parent"
def OS = ["2008R2", "2012R2", "2016"]

def buildTasks = [:]
for (int i = 0; i < OS.size(); i++) {
    buildTasks[i] = {
        stage("Build OS ${OS[i]}") {
            steps {
                build job:'packer-BaseOS', parameters: [
                    string(name: 'OSVersion', value: OS[i])
                ],
                wait: true
            }
        }
    }
}

pipeline {
    agent { label 'packer' }
    environment {
        // Packer directories
        packer_build_directory = "D:/PackerBuilds/"
        packer_exe_path = "D:/Packer/packer.exe"
        // Sets permanent cache location for downloaded isos
        PACKER_CACHE_DIR = "D:/PackerCache/"
    }
    // parameters {
    //     choice(
    //         // OS Version to build.
    //         name: 'OSVersion',
    //         choices:"2008R2\n2012R2\n2016\nALL",
    //         description: "Operating System Version"
    //     )
    //     choice(
    //         name: 'DestinationVCenter',
    //         choices: "DEN3\nDEN2\nSEA1\nSEA2\nDEN4",
    //         description: "Destination vCenter"
    //     )
    // }
    stages {
        stage('Build OS') {
            steps {
                powershell '''
                    Write-Host "Made it to powershell.  Value of BT: $($env:buildTasks)"
                '''
            }
            // parallel {buildTasks}
        }
        stage('Update OS') {
            steps {
                build job: 'packer-Updates', parameters: [
                    string(name: 'OSVersion', value: OS[1])
                ],
                wait: true
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

