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
		withCredentials([string(credentialsId: 'RafaelAzPass', variable: 'Az_pass')]) {
		sh '''
		az account clear
		az login -u rafael.martinez@globant.com -p $Az_pass
		az account set -s a7b78be8-6f3c-4faf-a43d-285ac7e92a05
		sh
		'''
		cleanWs()
	        }
    		}	
		}

  stage('Az Account') {
steps {
             pwsh '''
             $password = ConvertTo-SecureString -String "4420528e-9168-41fa-96c2-b78c99aff30c" -AsPlainText -Force
             $Credential = New-Object System.Management.Automation.PSCredential ('ea7672ef-f009-47fe-8b74-114a7d99b257', $password)
             Connect-AzAccount -Credential $Credential -Tenant 'c160a942-c869-429f-8a96-f8c8296d57db' -ServicePrincipal -Subscription 'a7b78be8-6f3c-4faf-a43d-285ac7e92a05'
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
