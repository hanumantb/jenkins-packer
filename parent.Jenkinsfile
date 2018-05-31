def buildDesc = "Packer - Deploy \\ Parent"
def OS = ["2008R2", "2012R2", "2016"]
def lastRun;

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
        stage('Set Description') {
            steps {
                script {
                    currentBuild.description = "${buildDesc}"
                }
            }
        }
        stage('Build OS') {
            // Run OS builds in parallel
            //TODO: It would be nice to dynamically do this, but it seems difficult using a declaritive pipeline
            parallel {
                stage("Build OS 2008R2") {
                    steps {
                        build job:'packer-BaseOS', propagate: false, parameters: [
                            string(name: 'OSVersion', value: '2008R2')
                        ],
                        wait: true
                    }
                }
                stage("Build OS 2012R2") {
                    steps {
                        build job:'packer-BaseOS', parameters: [
                            string(name: 'OSVersion', value: '2012R2')
                        ],
                        wait: true
                    }
                }
                stage("Build OS 2016") {
                    steps {
                        build job:'packer-BaseOS', parameters: [
                            string(name: 'OSVersion', value: '2016')
                        ],
                        wait: true
                    }
                }
            }
        }
        stage('Update OS') {
            parallel {
                stage("Update 2008R2") {
                    when {
                        expression {
                            lastRun = readJSON file: "${packer_build_directory}/2008R2-BuildOS-LastBuild.json"
                            "${lastRun.Status}" == 'SUCCESS'}
                    }
                    steps {
                        build job: 'packer-Updates', parameters: [
                            string(name: 'OSVersion', value: OS[1])
                        ],
                        wait: true
                    }
                }
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

