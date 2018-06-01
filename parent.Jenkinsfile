def buildDesc = "Packer - Parent Pipeline"
def OS = ["2008R2", "2012R2", "2016"]
def lastRun;
def Destinations = ["DEN3", "DEN4", "DEN2", "SEA1", "SEA2"]
// def builds;  //TODO: Is it necessary to put these up here?

// Set up jobs
def buildOSJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    buildOSJobs["Build OS ${OS.getAt(i)}"] = {
        build job: 'packer-BaseOS', parameters: [
        string(name: 'OSVersion', value: OS.getAt(i)]
    }
}

def updateJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    updateJobs["Update OS ${OS.getAt(i)}"] = {
        build job: 'packer-Updates', parameters: [
            string(name: 'OSVersion', value: OS.getAt(i))]
    }
}

def deployJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    for(int j = 0; j < Destinations.size(); j++) {
        deployJobs["Deploy OS ${OS.getAt(i)} to ${Destinations.get(j)}"] = {
            build job: 'packer-Deploy', parameters: [
            string(name: 'OSVersion', value: OS.getAt(i)),
            string(name: 'DestinationVcenter', value: Destinations[j])], wait: true
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
    stages {
        stage('Set Description') {
            steps {
                script {
                    currentBuild.description = "${buildDesc}"
                }
            }
        }
        stage('Build OS') {
            steps {
                script {
                    parallel buildOSJobs
                }
            }
        }
        stage('Update OS') {
            steps {
                script {
                    parallel updateJobs
                }
            }
        }
        stage('Deploy OS') {
            steps {
                script {
                    parallel deployJobs
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

