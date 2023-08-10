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
        DATE = new Date().format('yy.M')
        TAG = "${DATE}.${BUILD_NUMBER}"
        dockerimagename = "pancaaa/hello-world"
        dockerImage = ""
        registryCredential = 'registry-push'
    }
    stages {
        stage('Checkout Source') {
            steps {
                git url: 'https://github.com/war3wolf/mvn-springboot.git', branch: 'master',
                credentialsId: 'Github Connection'
            }
        }
        stage ('Build Project') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    dockerImage = docker.build dockerimagename
                }
            }
        }
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
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/config config current-context'
                    sh 'pwd'
                    // sh 'kubectl --kubeconfig=/home/jenkins/.kube/config apply -f ./deployment.yml'        
                }
            }
        }
    }
}