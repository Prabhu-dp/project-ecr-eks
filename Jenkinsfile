pipeline {
      environment {
        imagename = "423913260810.dkr.ecr.ap-south-1.amazonaws.com/greenstest"
        
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
          sh "aws ecr get-login-password --region ap-south-1 |docker login --username AWS --password-stdin 423913260810.dkr.ecr.ap-south-1.amazonaws.com"
          sh "docker push $imagename:$BUILD_NUMBER"
          
         }
       }
     }
    stage('Remove Unused docker image') {
      steps{
         sh "docker rmi $imagename:$BUILD_NUMBER"

      }
    }
    stage('Deploy K8S') {
      steps {
          sh "sed -i 's|BUILD_NUMBER|$BUILD_NUMBER|g' k8s.yaml"
          sh "kubectl apply -f k8s-service.yaml"
          sh "kubectl apply -f k8s.yaml"
      }
    }
  }
}
