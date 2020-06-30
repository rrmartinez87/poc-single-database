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
withCredentials([azureServicePrincipal('jenkins-sp-sql2')])
withCredentials([string(credentialsId: 'RafaelAzPass', variable: 'Az_pass')])	    
		    {
pwsh "$User = 'rafael.martinez@globant.com'"
pwsh "$PWord = ConvertTo-SecureString -String '{$Az_pass}' -AsPlainText -Force"
pwsh "$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord"
pwsh "Connect-AzAccount -Credential $Credential -Tenant '$ZURE_TENANT_ID' -ServicePrincipal"
        }
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
		 terraform plan -no-color -out out.plan
                 terraform apply -no-color out.plan
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
