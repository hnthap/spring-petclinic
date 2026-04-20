@Library('my-shared-library') _

pipeline {
  agent any
  stages {
    stage('Compile') {
      steps { compileApp() }
    }
    stage('Unit Test') {
      steps { runUnitTests() }
    }
    stage('Scan SonarQube') {
      steps { scanSonar("${env.SONAR_HOST}") }
    }
    stage('Deploy Nexus') {
      when { anyOf { branch 'uat/*'; branch 'main' } }
      steps { deployNexus("${env.NEXUS_REGISTRY}") }
    }
    stage('Deploy Application') {
      when { anyOf { branch 'uat/*'; branch 'main' } }
      steps { deployApp(env.BRANCH_NAME, "${env.NEXUS_REGISTRY}") }
    }
    stage('Check Health') {
      when { anyOf { branch 'uat/*'; branch 'main' } }
      steps {
        script {
          def port = env.BRANCH_NAME == 'main' ? '8083' : '8084'
          sh "sleep 15 && curl -f http://${env.APP_TARGET_IP}:${port}/actuator/health || exit 1"
        }
      }
    }
  }
  
  post {
      success {
          slackSend(color: 'good', message: "Build Successful: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
      }
      failure {
          slackSend(color: 'danger', message: "Build Failed: ${env.JOB_NAME} [${env.BUILD_NUMBER}]")
      }
  }
}
