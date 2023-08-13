pipeline {
    agent any //{
    // kubernetes {
    //   	cloud 'devops-cluster-dev'
    //   	defaultContainer 'worker'
    //   }
    // }

    tools{
        maven 'Maven 3.9.4'
    }

    environment {
        // DATE = new Date().format('yy.M')
        // TAG = "${DATE}.${BUILD_NUMBER}"
        dockerimagename = "pancaaa/springboot-app"
        dockerImage = ""
        registryCredential = 'dockerhublogin'
        gitUrl = 'https://github.com/war3wolf/mvn-springboot.git'
        gitBranch = 'staging'
    }
    stages {
        stage('Checkout Source') {
            steps {
                sh 'rm -rf *'
                url: gitUrl,
                git branch: gitBranch,
                credentialsId: 'Github Connection'
            }
        }
        stage ('Build Project') {
            steps {
                sh 'mvn package spring-boot:repackage'
                sh 'mvn clean install -DskipTests'
            }
        }
        // stage('Docker Build') {
        //     steps {
        //         script {
        //             dockerImage = docker.build dockerimagename
        //         }
        //     }
        // }
	    // stage('Pushing Image') {
        //     steps{
        //         script {
        //             docker.withRegistry('https://registry.hub.docker.com', registryCredential) {
        //             dockerImage.push("latest")
        //             }
        //         }   
        //     }
        // }

        stage('Deploy to Kube Cluster  '){
            steps{
                script{
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config config current-context'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config delete deployment hello-world'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config delete service hello-world'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f /var/lib/jenkins/workspace/Demo_Deploy_staging/deployment.yaml'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f /var/lib/jenkins/workspace/Demo_Deploy_staging/service.yaml'        
                }
            }
        }
    }
}