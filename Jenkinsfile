import groovy.json.JsonOutput
def getGitCommitHash() {
  return sh (script: "git log -n 1 --pretty=format:'%h'", returnStdout: true)
}
def getGitBranchName() {
    // return scm.branches[0].name
    return "master"
}
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
    def project = 'linhbkhn95'
    def appName = 'aseorder'
    // def privateRegistry = 'hub.docker.com'
    def privateRegistry = 'example.com'

    def workspace = pwd()
    def BRANCH_NAME = getGitBranchName();

    def imageTag = "${project}/${appName}:${BRANCH_NAME}"
    def composerTag = "$appName${env.BRANCH_NAME}${env.BUILD_NUMBER}"

    stage('Checkout source code') {
	    // if (env.BRANCH_NAME.matches("master|release-.*")) {
	    //     notifySlack('Running')
      //   }
	        notifySlack('Running')

	    //fix permission
          // sh ("sudo chown -R jenkins:jenkins .")
          checkout scm
          gitCommitHash = getGitCommitHash()
          imageTag = imageTag + "." + gitCommitHash
          dockerTag = "${BRANCH_NAME}" + "." + gitCommitHash
          dockerImage = "${privateRegistry}/${imageTag}"
    }

    // stage('Build') {
    //     withEnv(["PATH=$PATH:~/.local/bin"]){
    //       sh 'docker-compose build'
    //     }
    // }
  stage('Install dependencies') {
        try {
            def TEST_EXIT_CODE = sh(script:"docker run --rm -v `pwd`:/app/${appName} -w /app/${appName} node:11 sh -c 'npm cache clean --force && rm -rf node_modules && rm -rf package-lock.json && npm install'", returnStatus: true)
            assert TEST_EXIT_CODE == 0
        } catch (AssertionError e) {
            notifySlack('FAILURE')
            throw e
        }
    }

  stage('Run Testing'){
        try{
            sh 'echo 123'

            // def TEST_EXIT_CODE = sh(script:"docker run --rm -v `pwd`:/app/${appName} -w /app/${appName} node:11 sh -c 'npm test'", returnStatus: true)
           // assert TEST_EXIT_CODE == 0
        } catch (AssertionError e) {
            notifySlack('FAILURE')
            throw e
        }
   }
   stage('Sonarqube analysis'){
        try{
          sh 'echo sonar-queue'
          // def scannerHome = tool 'SonarQube Scanner';
          //   withSonarQubeEnv {
          //     sh "${scannerHome}/bin/sonar-scanner"
          //     sonarToken = "${SONAR_AUTH_TOKEN}"
          //     sonarHost = "${SONAR_HOST_URL}"
          //   }

        } catch (AssertionError e) {
            notifySlack('FAILURE')
            throw e
        }
    }
    stage('Build and push docker image to registry') {
      // unstash 'frontend'
      docker.withRegistry('', 'exampleregistry') {
            def customImage = docker.build("${imageTag}", "-f ./Dockerfile .")
            try {
              customImage.push()
              sh "docker rmi -f ${imageTag} ${dockerImage}"

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
        docker.withRegistry('', 'linhbkhn95') {
          sh "docker pull ${imageTag}"
          // sh 'docker-compose up -d'
          sh "docker run -d --network=host  --restart=always ${imageTag}"
          notifySlack('SUC CMN CESS');
        }
      }
    }

   
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