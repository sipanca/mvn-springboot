pipeline {
    agent any 

    // Build Number for Docker Image
    environment {
        appsName = "springboot-app"
        version =  "${env.GIT_COMMIT}"
        dockerImage = "${appsName}:${version}"
        registry = "pancaaa/$appsName"
        registryCredential = 'dockerhublogin'

        gitUrl = 'https://github.com/war3wolf/mvn-springboot.git'
        gitBranch = 'development'
    }
    
    // environment {
    //     appsName = "springboot-app"
    //     build_number = "${env.BUILD_ID}-${env.GIT_COMMIT}"
    //     registry = "pancaaa/$appsName"
    //     registryCredential = 'dockerhublogin'
    //     dockerImage = ""
    //     gitUrl = 'https://github.com/war3wolf/mvn-springboot.git'
    //     gitBranch = 'development'

    //     // BUILD_NUMBER = "development"
        
    // }

    stages {
        stage('Checkout Source') {
            steps {
                // sh 'rm -rf *'
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
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config config current-context'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f deployment/deployment.yaml'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f deployment/service.yaml'
                    // sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config rollout status deployment/deployment.yaml'        
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