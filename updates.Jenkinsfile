import hudson.model.Result
import jenkins.model.*

def buildDesc = "Packer - Updates \\ ${OSVersion}"

def getLastJobStatus(osVersion, task) {
    lastRun = readJSON file: "${packer_build_directory}/${osVersion}-${task}-LastRun.json"
    return lastRun.Status == 'SUCCEEDED'
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
            when {
                expression {
                    getLastJobStatus(osVersion, "BuildOS")
                }
            }
            steps {
                powershell '''
                    .\\update\\Build-Updates.ps1 -OSVersion $env:OSVersion -OutputDirectory $env:packer_build_directory
                '''
            }
        }
        stage('Update Last Run When Failed') {
            when {
                expression {
                    !(getLastJobStatus(osVersion, "BuildOS"))
                }
            }
            steps {
                powershell '''
                    Write-Host "Updating LastRun to FAILED."
                    . .\\Helper-Functions.ps1
                    Set-LastBuild -OSVersion $env:OSVersion -Status FAILED -BuildDirectory $env:packer_build_directory -Task Updates
                '''
                script {
                    build.@result = hudson.model.Result.ABORTED
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

