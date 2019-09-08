pipeline {
  agent any
  stages {
    stage('Info') {
      steps {
        sh 'echo ${BRANCH_NAME}'
      }
    }
    stage('Unit Test') {
      agent {
        docker {
          image 'maven:3.6.1-jdk-11-slim'
          args '-v $HOME/.m2:/root/.m2:z -u root'
        }

      }
      steps {
        sh 'echo "Running unit tests..."'
        sh 'mvn clean test'
      }
    }
    stage('Unit Integration Test') {
      agent {
        docker {
          image 'maven:3.6.1-jdk-11-slim'
          args '-v $HOME/.m2:/root/.m2:z -u root'
        }

      }
      steps {
        sh 'echo "Running unit integration tests..."'
        sh 'mvn clean integration-test'
      }
    }
    stage('Code quality') {
      steps {
        sh 'echo "Checking code quality..."'
      }
    }
    stage('Security check') {
      steps {
        sh 'echo "Pushing code to Security team and wait for approval..."'
      }
    }
    stage('Build Application') {
      agent {
        docker {
          image 'maven:3.6.1-jdk-11-slim'
          args '-v $HOME/.m2:/root/.m2:z -u root'
        }

      }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'echo "Building demo application..."'
        sh 'mvn clean package -U'
      }
    }
    stage('Docker Build') {
      agent {
        docker {
          image 'docker'
          args '--privileged=true'
        }

      }
      when {
        branch 'develop'
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        script {
          dockerImage = docker.build("raymondmm/demo-app:latest", "-f Dockerfile .")
        }

      }
    }
    stage('Docker Run') {
      agent {
        docker {
          image 'docker'
          args '--privileged=true'
        }

      }
      when {
        branch 'develop'
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        script {
          dockerContainer = dockerImage.run("-p8443:8443 --name demo-app -e TZ=Europe/Amsterdam")
        }

      }
    }
    stage('Smoke Test') {
      agent any
      when {
        branch 'develop'
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'curl https://localhost:8443 -k -s -f -o /dev/null && echo "SUCCESS" || echo "ERROR"'
      }
    }
//    stage('Cucumber / Selenide Test') {
//      agent any
//      when {
//        branch 'develop'
//      }
//      steps {
//        build 'demo-app-cucumber'
//      }
//    }
  }
//  post {
//    always {
//      script {
//        if (dockerContainer) {
//          dockerContainer.stop()
//        }
//      }
//    }
//  }
}
