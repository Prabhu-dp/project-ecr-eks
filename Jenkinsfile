pipeline {
      environment {
        imagename = "greensdevops.jfrog.io/cicdtest/test"
        registryCredential = 'docker-jfrog'
        
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
          sh "docker build -t $imagename:$BUILD_NUMBER ."
        }
      }
     }
     stage('Deploy Image') {
      steps{
        script {
          withCredentials([usernamePassword(credentialsId: registryCredential , usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
          sh "docker login -u $USERNAME -p $PASSWORD"
          sh "docker push $imagename:$BUILD_NUMBER"
          }
         }
       }
     }
    stage('Remove Unused docker image') {
      steps{
         sh "docker rmi $imagename:$BUILD_NUMBER"

      }
    }
    stage('string (secret text)') {
      steps {
        script {
          withCredentials([
            string(
              credentialsId: 'aws-id',
              variable: 'aws-id')
          ]) {
            print 'aws-id=' + aws-id
            print 'aws-id.collect { it }=' + aws-id.collect { it }
          }
        }
      }
    }
  }
}
