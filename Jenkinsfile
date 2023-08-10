pipeline {
    // agent {
    // kubernetes {
    //   	cloud 'devops-cluster-dev'
    //   	defaultContainer 'worker'
    //   }
    // }
    environment {
        DATE = new Date().format('yy.M')
        TAG = "${DATE}.${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout Source') {
            steps {
                git url: 'https://github.com/war3wolf/mvn-springboot.git', branch: 'main',
                credentialsId: 'Github Connection'
            }
        }
        stage ('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    docker.build("pancaaa/hello-world:${TAG}")
                }
            }
        }
	    stage('Pushing Docker Image to Dockerhub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_credential') {
                        docker.image("pancaaa/hello-world:${TAG}").push()
                        docker.image("pancaaa/hello-world:${TAG}").push("latest")
                    }
                }
            }
        }
        stage('Deploy'){
            steps {
                sh "docker stop hello-world | true"
                sh "docker rm hello-world | true"
                sh "docker run --name hello-world -d -p 9004:8080 panca/hello-world:${TAG}"
            }
        }
    }
}