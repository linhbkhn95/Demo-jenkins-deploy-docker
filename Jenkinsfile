import groovy.json.JsonOutput

node('master') {
 
  //  agent any
  //  environment {
  //   FRONTEND_GIT = 'https://github.com/sontung0/tutorial-jenkins-frontend.git'
  //   FRONTEND_BRANCH = 'master'
  //   FRONTEND_IMAGE = 'tutorial-jenkins-frontend'
  //   FRONTEND_SERVER = '1.2.3.4'
  //   FRONTEND_SERVER_DIR = './app'
  // }
 
  try {
    def project = 'linbkhn95'
    def appName = 'demo_jenkins'
    def privateRegistry = 'hub.docker.com'
    def workspace = pwd()
    def imageTag = "${project}/${appName}:${env.BRANCH_NAME}"
    def composerTag = "$appName${env.BRANCH_NAME}${env.BUILD_NUMBER}"
    
    stage('Checkout source code') {
	    if (env.BRANCH_NAME.matches("master|release-.*")) {
	        notifySlack('Running')
        }

	    //fix permission
          sh ("sudo chown -R jenkins:jenkins .")
          checkout scm
          gitCommitHash = getGitCommitHash()
          imageTag = imageTag + "." + gitCommitHash
          dockerTag = "${env.BRANCH_NAME}" + "." + gitCommitHash
          dockerImage = "${privateRegistry}/${imageTag}"
    }

    stage('Build') {
        withEnv(["PATH=$PATH:~/.local/bin"]){
          sh 'docker-compose build'
        }
    }

    stage('Test') {
      sh 'echo 123'
    }
    stage('Build Image') {
      // unstash 'frontend'
      docker.withRegistry('', 'linhbkhn95') {
            def customImage = docker.build("${imageTag}", "-f ./Dockerfile .")
            try {
              customImage.push()
              notifySlack("Build Success")
            } catch (AssertionError e) {
              notifySlack('FAILURE check security analysis')
              throw e
            } finally {
                sh "docker rmi -f ${imageTag} ${dockerImage}"
            }      
          }
      
      
    }
    stage('Deploy') {
      withEnv(["PATH=$PATH:~/.local/bin"]){
        // sh 'docker-compose down'
        sh 'docker-compose up -d'
      }
    }

    notifySlack('SUC CMN CESS');
   
  } catch (e) {
    notifySlack('ERROR');
    throw e
  }
}

def notifySlack(text) {
     sh "echo ${text}"
    // def slackURL = 'https://hooks.slack.com/services/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'
    // def jenkinsIcon = 'https://wiki.jenkins-ci.org/download/attachments/2916393/logo.png'
    // def channel = 'droneit'

    // def payload = JsonOutput.toJson([text: text,
    //     channel: channel,
    //     username: "Jenkins",
    //     icon_url: jenkinsIcon
    // ])

    // sh "curl -X POST --data-urlencode \'payload=${payload}\' ${slackURL}"
}