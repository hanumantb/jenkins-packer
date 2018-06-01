def buildDesc = "Packer - Parent Pipeline"
def OS = ["2008R2", "2012R2", "2016"]
def lastRun;
def Destinations = ["DEN3", "DEN4", "DEN2", "SEA1", "SEA2"]
// def builds;  //TODO: Is it necessary to put these up here?

// Set up jobs
def buildOSJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    buildOSJobs["Build OS ${OS[i]}"] = {
        build job: 'packer-BaseOS', parameters: [
        string(name: 'OSVersion', value: "${OS[i]}")]
    }
}

def updateJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    updateJobs["Update OS ${OS[i]}"] = {
        build job: 'packer-Updates', parameters: [
            string(name: 'OSVersion', value: "${OS[i]}")]
    }
}

def deployJobs = [:]
for(int i = 0; i < OS.size(); i++) {
    deployJobs["Deploy OS ${OS[i]}"] = {
        build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "${OS[i]}"),
        string(name: 'DestinationVcenter', value: "DEN3")], wait: true

        build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "${OS[i]}"),
        string(name: 'DestinationVcenter', value: "DEN4")], wait: true

        build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "${OS[i]}"),
        string(name: 'DestinationVcenter', value: "SEA1")], wait: true

        build job: 'packer-Deploy', parameters: [
        string(name: 'OSVersion', value: "${OS[i]}"),
        string(name: 'DestinationVcenter', value: "SEA2")], wait: true
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

            // Run OS builds in parallel
            //TODO: It would be nice to dynamically do this, but it seems difficult using a declaritive pipeline
            // parallel {
            //     stage("Build OS 2008R2") {
            //         steps {
            //             build job:'packer-BaseOS', propagate: false, parameters: [
            //                 string(name: 'OSVersion', value: '2008R2')
            //             ],
            //             wait: true
            //         }
            //     }
            //     stage("Build OS 2012R2") {
            //         steps {
            //             build job:'packer-BaseOS', parameters: [
            //                 string(name: 'OSVersion', value: '2012R2')
            //             ],
            //             wait: true
            //         }
            //     }
            //     stage("Build OS 2016") {
            //         steps {
            //             build job:'packer-BaseOS', parameters: [
            //                 string(name: 'OSVersion', value: '2016')
            //             ],
            //             wait: true
            //         }
            //     }
            // }
        }
        stage('Update OS') {
            steps {
                script {
                    parallel updateJobs
                }
            }
            // parallel {
            //     stage("Update 2008R2") {
            //         when {
            //             expression {
            //                 lastRun = readJSON file: "${packer_build_directory}/2008R2-BuildOS-LastRun.json"
            //                 "${lastRun.Status}" == 'SUCCEEDED'
            //             }
            //         }
            //         steps {
            //             build job: 'packer-Updates', parameters: [
            //                 string(name: 'OSVersion', value: '2008R2')
            //             ],
            //             wait: true
            //         }
            //     }
            //     stage("Update 2012R2") {
            //         when {
            //             expression {
            //                 lastRun = readJSON file: "${packer_build_directory}/2012R2-BuildOS-LastRun.json"
            //                 "${lastRun.Status}" == 'SUCCEEDED'
            //             }
            //         }
            //         steps {
            //             build job: 'packer-Updates', parameters: [
            //                 string(name: 'OSVersion', value: '2012R2')
            //             ],
            //             wait: true
            //         }
            //     }
            //     stage("Update 2016") {
            //         when {
            //             expression {
            //                 lastRun = readJSON file: "${packer_build_directory}/2016-BuildOS-LastRun.json"
            //                 "${lastRun.Status}" == 'SUCCEEDED'
            //             }
            //         }
            //         steps {
            //             build job: 'packer-Updates', parameters: [
            //                 string(name: 'OSVersion', value: '2016')
            //             ],
            //             wait: true
            //         }
            //     }
            // }
        }
        stage('Deploy OS') {
            steps {
                script {
                    parallel deployJobs
                }
            }
            // def stepsForParallel = [:]
            // for(int i = 0; i < Destinations.size(); i++) {
            //     def dest = Destinations.get(i)
            //     stepsForParallel["Deploy ${dest}"] = {
            //         build job: 'packer-Deploy', parameters: [
            //         string(name: 'OSVersion', value: '2008R2'),
            //         string(name: 'DestinationVCenter', value: dest)
            //         ],
            //         wait: true
            //     }
            // }
        }
            //parallel {
                // stage("Deploy 2008R2") {
                //     when {
                //         expression {
                //             lastRun = readJSON file: "${packer_build_directory}/2008R2-Updates-LastRun.json"
                //             "${lastRun.Status}" == 'SUCCEEDED'
                //         }
                //     }
                //     steps {
                //         def builds = []
                //         for(Dest in Destinations) {
                //             curJob = {
                //                     build job: 'packer-Deploy', parameters: [
                //                     string(name: 'OSVersion', value: '2008R2'),
                //                     string(name: 'DestinationVCenter', value: Dest)
                //                 ],
                //                 wait: true
                //             }
                //             builds.add(curJob)
                //         }
                //         parallel(builds)
                //     }
                // }
                // stage("Deploy SEA1") {
                //     when {
                //         expression {
                //             lastRun = readJSON file: "${packer_build_directory}/2008R2-Updates-LastRun.json"
                //             "${lastRun.Status}" == 'SUCCEEDED'
                //         }
                //     }
                //     steps {
                //         build job: 'packer-Deploy', parameters: [
                //             string(name: 'OSVersion', value: '2008R2'),
                //             string(name: 'DestinationVCenter', value: 'SEA1')
                //         ],
                //         wait: true
                //     }
                // }
                // stage("Deploy DEN4") {
                //     when {
                //         expression {
                //             lastRun = readJSON file: "${packer_build_directory}/2008R2-Updates-LastRun.json"
                //             "${lastRun.Status}" == 'SUCCEEDED'
                //         }
                //     }
                //     steps {
                //         build job: 'packer-Deploy', parameters: [
                //             string(name: 'OSVersion', value: '2008R2'),
                //             string(name: 'DestinationVCenter', value: 'DEN4')
                //         ],
                //         wait: true
                //     }
                // }
            //}
        //}
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

