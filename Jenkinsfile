pipeline {
    agent any
    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'ref', value: '$.ref'],
                [key: 'commits', value: '$.commits[*].modified']
            ],
            causeString: 'Triggered on $ref',
            tokenCredentialId: 'git-webhook-token',
            printContributedVariables: true,
            printPostContent: true,
            silentResponse: false
        )
    }
    environment {
        PACKER_BASE_DIR = 'packer/base'
        PACKER_EXTEND_DIR = 'packer/extend'
    }
    stages {
        stage('Check Changes in Packer Base Directory') {
            steps {
                script {
                    def changesDetected = false
                    for (commit in env.commits.tokenize(',')) {
                        def changedFiles = sh(script: "git diff-tree --no-commit-id --name-only -r ${commit}", returnStdout: true).trim().split('\n')
                        for (file in changedFiles) {
                            if (file.startsWith(PACKER_BASE_DIR)) {
                                changesDetected = true
                                break
                            }
                        }
                        if (changesDetected) break
                    }
                    
                    if (!changesDetected) {
                        echo "No changes detected in ${PACKER_BASE_DIR}"
                        currentBuild.result = 'SUCCESS'
                        error("No relevant changes detected")
                    }
                }
            }
        }
        stage('Validate Base Packer Files') {
            steps {
                script {
                    def changedFiles = []
                    for (commit in env.commits.tokenize(',')) {
                        def files = sh(script: "git diff-tree --no-commit-id --name-only -r ${commit}", returnStdout: true).trim().split('\n')
                        for (file in files) {
                            if (file.startsWith(PACKER_BASE_DIR)) {
                                changedFiles.add(file)
                            }
                        }
                    }
                    
                    changedFiles.unique().each { file ->
                        echo "Validating ${file}"
                        sh "packer validate ${file}"
                    }
                }
            }
        }
        stage('Build Base Packer Images') {
            steps {
                script {
                    def changedFiles = []
                    for (commit in env.commits.tokenize(',')) {
                        def files = sh(script: "git diff-tree --no-commit-id --name-only -r ${commit}", returnStdout: true).trim().split('\n')
                        for (file in files) {
                            if (file.startsWith(PACKER_BASE_DIR)) {
                                changedFiles.add(file)
                            }
                        }
                    }
                    
                    changedFiles.unique().each { file ->
                        echo "Building image from ${file}"
                        sh "packer build ${file}"
                    }
                }
            }
        }
        stage('Check Changes in Packer Extended Directory') {
            steps {
                script {
                    def changesDetected = false
                    for (commit in env.commits.tokenize(',')) {
                        def changedFiles = sh(script: "git diff-tree --no-commit-id --name-only -r ${commit}", returnStdout: true).trim().split('\n')
                        for (file in changedFiles) {
                            if (file.startsWith(PACKER_EXTEND_DIR)) {
                                changesDetected = true
                                break
                            }
                        }
                        if (changesDetected) break
                    }
                    
                    if (!changesDetected) {
                        echo "No changes detected in ${PACKER_EXTEND_DIR}"
                        currentBuild.result = 'SUCCESS'
                        error("No relevant changes detected")
                    }
                }
            }
        }
        stage('Validate Extended Packer Files') {
            steps {
                script {
                    def changedFiles = []
                    for (commit in env.commits.tokenize(',')) {
                        def files = sh(script: "git diff-tree --no-commit-id --name-only -r ${commit}", returnStdout: true).trim().split('\n')
                        for (file in files) {
                            if (file.startsWith(PACKER_EXTEND_DIR)) {
                                changedFiles.add(file)
                            }
                        }
                    }
                    
                    changedFiles.unique().each { file ->
                        echo "Validating ${file}"
                        sh "packer validate ${file}"
                    }
                }
            }
        }
        stage('Build Extened Packer Images') {
            steps {
                script {
                    def changedFiles = []
                    for (commit in env.commits.tokenize(',')) {
                        def files = sh(script: "git diff-tree --no-commit-id --name-only -r ${commit}", returnStdout: true).trim().split('\n')
                        for (file in files) {
                            if (file.startsWith(PACKER_EXTEND_DIR)) {
                                changedFiles.add(file)
                            }
                        }
                    }
                    
                    changedFiles.unique().each { file ->
                        echo "Building image from ${file}"
                        sh "packer build ${file}"
                    }
                }
            }
        }
       // Upload Images to ProxMox 
      // ToDo: Add Terraform and Ansible Stages
    }
}

