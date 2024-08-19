pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Update the git Repo URL
                git url: 'https://github.com/Anushams3590/ARM.git', branch: 'main'
            }
        }

        stage('Input1') {
            steps {
                script {
                    def result = sh(script: 'python3 ip_print.py tests/input_files/input1.json', returnStatus: true)
                    if (result != 0) {
                        error "ip_print.py failed on input1.json"
                    }
                }
            }
        }

        stage('Input2') {
            steps {
                script {
                    def result = sh(script: 'python3 ip_print.py tests/input_files/input2.json', returnStatus: true)
                    if (result != 0) {
                        error "ip_print.py failed on input2.json"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
