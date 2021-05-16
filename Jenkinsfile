pipeline {
    agent {
      node {
        label "master"
      } 
    }

    stages {
      stage('fetch_latest_code') {
        steps {
          git branch: 'master', url: 'https://github.com/skabhi003/terra.git'
        }
      }

      stage('TF Init&Plan') {
        steps {
          sh 'terraform init'
          
        }      
      }

      stage('TF Apply') {
        steps {
          sh 'terraform apply -auto-approve -input=false'
        }
      }
      
      stage('Ansible') {
        steps {
          ansiblePlaybook credentialsId: 'awskey', installation: 'myAnsible', playbook: 'task.yml'
        }
      }
    } 
  }
