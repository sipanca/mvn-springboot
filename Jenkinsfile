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
        dockerimagename = "pancajuntak/hello-world"
        dockerImage = ""
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
	    stage('Pushing Image') {
            environment {
               registryCredential = 'dockerhublogin'
            }
            steps{
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
                    dockerImage.push("latest")
                    }
                }   
            }
        }
        // stage('Deploy'){
        //     steps {
        //         sh "docker stop hello-world | true"
        //         sh "docker rm hello-world | true"
        //         sh "docker run --name hello-world -d -p 9004:8080 panca/hello-world:latest"
        //     }
        // }

        stage('Deploy to Kube Cluster  '){
            steps{
                script{
                    kubernetesDeploy(configs: "deployment.yaml", "service.yaml")        
                }
            }
        }
    }
}