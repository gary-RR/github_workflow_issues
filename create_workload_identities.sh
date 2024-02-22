githubOrganizationName='gary-RR'
githubRepositoryName='github_workflow_issues'

#****************************************************************Test********************************************************************************************
testApplicationRegistrationDetails=$(az ad app create --display-name 'github_workflow_issues')
testApplicationRegistrationObjectId=$(echo $testApplicationRegistrationDetails | jq -r '.id')
testApplicationRegistrationAppId=$(echo $testApplicationRegistrationDetails | jq -r '.appId')

az ad app federated-credential create \
   --id $testApplicationRegistrationObjectId \
   --parameters "{\"name\":\"github_workflow_issues\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:${githubOrganizationName}/${githubRepositoryName}:environment:Test\",\"audiences\":[\"api://AzureADTokenExchange\"]}"

az ad app federated-credential create \
   --id $testApplicationRegistrationObjectId \
   --parameters "{\"name\":\"github_workflow_issues-branch\",\"issuer\":\"https://token.actions.githubusercontent.com\",\"subject\":\"repo:${githubOrganizationName}/${githubRepositoryName}:ref:refs/heads/main\",\"audiences\":[\"api://AzureADTokenExchange\"]}"


#*******************************************************Create a test Resource group and a SP and give contibutor access to the SP.
testResourceGroupResourceId=$(az group create --name GithubWorkflowIssue --location westus3 --query id --output tsv)

# There is a bug in git bash and Azure CLI where we must remove the starting "/" from "/subscriptions"
testResourceGroupResourceId=${testResourceGroupResourceId:1}

az ad sp create --id $testApplicationRegistrationObjectId

az role assignment create \
   --assignee $testApplicationRegistrationAppId \
   --role Contributor \
   --scope $testResourceGroupResourceId

echo "AZURE_CLIENT_ID_TEST: $testApplicationRegistrationAppId"
echo "AZURE_TENANT_ID: $(az account show --query tenantId --output tsv)"
echo "AZURE_SUBSCRIPTION_ID: $(az account show --query id --output tsv)"


#Clean up
az group delete --resource-group GithubWorkflowIssue --yes --no-wait

git add .
git commit -m "Fixed RS name issue."
git push