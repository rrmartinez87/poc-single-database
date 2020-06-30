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
             $password = ConvertTo-SecureString -String "UxzPCy-xSL.2-aT707dE_T-2_mayDMBm21" -AsPlainText -Force
             $Credential = New-Object System.Management.Automation.PSCredential ('c6b8d3e1-b3ca-46fb-93af-d9348f3cd8a5', $password)
             Connect-AzAccount -Credential $Credential -Tenant 'c160a942-c869-429f-8a96-f8c8296d57db' -ServicePrincipal -Subscription 'a265068d-a38b-40a9-8c88-fb7158ccda23'
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
	    options {
                azureKeyVault(
                    credentialID: 'jenkins-sp-sql2', 
                    keyVaultURL: 'https://sqlsdtfstatekv-test-01.vault.azure.net/', 
                    secrets: [
                        [envVariable: 'TF_VAR_client_id', name: 'spn-id', secretType: 'Secret'],
                        [envVariable: 'TF_VAR_client_secret', name: 'spn-secret', secretType: 'Secret'],
                        [envVariable: 'StorageAccountAccessKey', name: 'storagekey', secretType: 'Secret']
                    ]
                )
            }		
            steps {
            sh '''
            export TF_VAR_client_id=$TF_VAR_client_id
            export TF_VAR_client_secret=$TF_VAR_client_secret
            terraform init -no-color -backend-config="storage_account_name=sqlsdtfstatestgtest" \
            -backend-config="container_name=sqlsdtfstate" \
            -backend-config="access_key=$StorageAccountAccessKey" \
            -backend-config="key=terraform.tfstate"
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
