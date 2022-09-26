pipeline {
      environment {
        imagename = ""
        registryCredential = 'docker-jfrog'
        dockerImage = ''
      }
     agent any
     stages {
      stage('Cloning Git') {
       steps {
      
        git credentialsId: 'gitlab-id', url: 'https://gitlab.com/saidamo/eks-ci-cd-sonarqube-jenkins.git'        
    
       }
     }
     stage('SonarQube analysis') {
        environment {
            scannerHome = tool 'SonarQube_4'
        }
        steps {
            withSonarQubeEnv('Sonarqube') {
                sh '''
                ${scannerHome}/bin/sonar-scanner \
                -D sonar.projectKey=cicd-key \
                -D sonar.projectName=cicd 
                '''
            }
        }
    }
     stage('Building image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
     }
     stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')

           }
         }
       }
     }
    stage('Remove Unused docker image') {
      steps{
         sh "docker rmi $imagename:$BUILD_NUMBER"
         sh "docker rmi $imagename:latest"

      }
    }
  }

