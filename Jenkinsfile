pipeline {
    agent any 

    environment {
        appsName = "springboot-app"
        version =  "${GIT_COMMIT}"
        dockerImage = "${appsName}:${version}"
        registry = "pancaaa/$appsName"
        registryCredential = 'dockerhublogin'

        gitUrl = 'https://github.com/war3wolf/mvn-springboot.git'
        gitBranch = 'development'
    }

    stages {
        stage('Checkout Source') {
            steps {
                sh 'rm -rf *'
                git branch: gitBranch,
                credentialsId: 'Github-Connection',
                url: gitUrl
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build registry + ":$version"

                }
            }
        }

	    stage('Pushing Image') {
            steps{
                script {
                    docker.withRegistry('', registryCredential) {
                    dockerImage.push()
                    sh "docker rmi -f $registry:$version"
                    }
                }   
            }
        }

        stage('Deploy to Kube Cluster'){
            steps{
                script{
                    sh ''' 
                    #!/bin/bash
                    sed -i "s/development/$version/g" deployment/deployment.yaml
                    kubectl config current-context && kubectl apply -f deployment/deployment.yaml  
                    '''

                    sh '''
                    #!/bin/bash
                    kubectl rollout status deployment/hello-world -n default --timeout=30s
                    echo "$RESULT" | grep -q "successfully"
                    if [ "$?" != "0" ]; then
                        echo "rollout failed"
                    fi
                    '''
                }
            }

        }
    }

    post {
        always {
            deleteDir()
        }

        success {
            echo "Release Success"
        }

        failure {
            echo "Release failed"
        }

        cleanup {
            echo "Clean up in post workspace"
            cleanWs()
        }
    }
}