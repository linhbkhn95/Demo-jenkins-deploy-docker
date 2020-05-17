import groovy.json.JsonOutput

node('master') {
  checkout scm
  //  agent any
  //  environment {
  //   FRONTEND_GIT = 'https://github.com/sontung0/tutorial-jenkins-frontend.git'
  //   FRONTEND_BRANCH = 'master'
  //   FRONTEND_IMAGE = 'tutorial-jenkins-frontend'
  //   FRONTEND_SERVER = '1.2.3.4'
  //   FRONTEND_SERVER_DIR = './app'
  // }
  try {
     
    notifySlack('BUILDING');

    stage('Build') {
        withEnv(["PATH=$PATH:~/.local/bin"]){
          sh 'docker-compose build'
        }
    }

    stage('Test') {
      sh 'echo 123'
    }
    stage('Build Image') {
      steps {
        unstash 'frontend'
        script {
          docker.withRegistry('', 'docker-hub') {
            def image = docker.build('frontend')
            image.push(BUILD_ID)
          }
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
  }
}

def notifySlack(text) {
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