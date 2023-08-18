pipeline {
    agent any 

    tools{
        maven 'Maven 3.9.4'
    }

    environment {
        appsName = "springboot-app"
        registry = "pancaaa/$appsName"
        registryCredential = 'dockerhublogin'
        dockerImage = ""

        gitUrl = 'https://github.com/war3wolf/mvn-springboot.git'
        gitBranch = 'development'

        BUILD_NUMBER = "development"
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
                    dockerImage = docker.build registry + ":$env.BUILD_NUMBER"
                }
            }
        }

	    stage('Pushing Image') {
            steps{
                script {
                    docker.withRegistry('', registryCredential) {
                    dockerImage.push()
                    sh "docker rmi -f $registry:$env.BUILD_NUMBER"
                    }
                }   
            }
        }

        stage('Deploy to Kube Cluster'){
            steps{
                script{
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config config current-context'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config delete deployment hello-world'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config delete service hello-world'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f deployment/deployment.yaml'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f deployment/service.yaml'        
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