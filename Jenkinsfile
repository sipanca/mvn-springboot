pipeline {
    agent any 

    tools{
        maven 'Maven 3.9.4'
    }

    triggers {
        pollSCM "* * * * *"
    }

    options {
        timestamps ()
        ansiColor("xterm")
    }

    // parameters {
    //     boleanParam(
    //         name: "RELEASE",
    //         description: "Build a release from current commit.",
    //         defaultValue: false)
    // }

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
        
        stage ('Build & Deploy SNAPSHOT') {
            steps {
                
                sh "mvn -B deploy"

                // sh 'mvn package spring-boot:repackage'
                // sh 'mvn clean install -DskipTests'
            }
        }

        // stage ('Release') {
        //     when {
        //         allof {
        //             sh 'rm -rf *'
        //             git branch: gitBranch,
        //             expression { param.RELEASE }
        //             credentialsId: 'Github-Connection',
        //             url: gitUrl
        //         }               
        //     }
        //     steps {
        //         sh "mvn -B release:prepare"
        //         sh "mvn -B release:perform"
        //     }
        // }

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
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f /var/lib/jenkins/workspace/Demo_Deploy_master/deployment.yaml'
                    sh 'kubectl --kubeconfig=/home/jenkins/.kube/dev-cluster/config apply -f /var/lib/jenkins/workspace/Demo_Deploy_master/service.yaml'        
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