pipeline {
    parameters {
        choice(
            choices: ['create', 'destroy'],
            description: 'Select action to perform',
            name: 'REQUESTED_ACTION'
        )
    }
    agent any
    	
    stages {

  stage('Az login') {
steps {
             pwsh '''
             install-module -name az -allowclobber -force
             $password = ConvertTo-SecureString -String "UxzPCy-xSL.2-aT707dE_T-2_mayDMBm21" -AsPlainText -Force
             $Credential = New-Object System.Management.Automation.PSCredential ('c6b8d3e1-b3ca-46fb-93af-d9348f3cd8a5', $password)
             Connect-AzAccount -Credential $Credential -Tenant 'c160a942-c869-429f-8a96-f8c8296d57db' -ServicePrincipal
             Set-AzSqlServer
            '''
         }
}
        stage('Clone repository') {
        steps {
            git branch: 'master', credentialsId: 'Github', url: 'https://github.com/rrmartinez87/poc-single-database.git'
            }
        }
	stage('Set Terraform path') {
        steps {
             script {
                 def tfHome = tool name: 'Terraform'
                  env.PATH = "${tfHome}:${env.PATH}"
             }
                 sh 'terraform -version'
            }
        }
        stage('Terraform Apply') {
            when {
                expression { params.REQUESTED_ACTION == 'create'}
	    }
	    
	        steps {
                sh '''
		 pwsh -c "terraform plan -no-color -out out.plan"
                 pwsh -c "terraform apply -no-color out.plan"
                '''
            }
        }
		stage('Terraform Destroy') {
            when {
                expression { params.REQUESTED_ACTION == 'destroy' }
            }
	    
            steps {
            sh '''
                terraform destroy -no-color --auto-approve
            '''
            }
        }
        stage('Clean WorkSpace') {
            steps {
                echo "Wiping workspace $pwd"
                cleanWs() 
            }
        }
    }
}
