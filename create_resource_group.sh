az group create --name rg-AzureSQLTest --location centralus --query id --output tsv
# /subscriptions/e6566f19-3eb5-436b-904f-fdd540b4fd58/resourceGroups/rg-AzureSQLTest
echo "AZURE_TENANT_ID: $(az account show --query tenantId --output tsv)"
echo "AZURE_SUBSCRIPTION_ID: $(az account show --query id --output tsv)"



# Lint
az bicep build --file ./deploy/modules/create_vnet_and_vpn.bicep
#Pre flight validation
az deployment group validate --resource-group rg-AzureSQLTest --template-file ./deploy/modules/create_vnet_and_vpn.bicep
# Deploy
az deployment group create --resource-group rg-AzureSQLTest --template-file ./deploy/modules/create_vnet_and_vpn.bicep

# Lint
az bicep build --file ./deploy/azure_sql_private_endpoint.bicep
#Pre flight validation
az deployment group validate --resource-group rg-AzureSQLTest --template-file ./deploy/azure_sql_private_endpoint.bicep --parameters environmentType=Test vmLinuxLoginUser='gary' vmLinuxLoginPassword='g@678219' vmWindowsLoginUser='gary' vmWindowsLoginPassword='g@678219' adminDBLoginName=gary adminDBPassword='H7$vdL&95xKo0Mj' databaseName=slaesfloor 
#Deploy
az deployment group create --resource-group rg-AzureSQLTest --template-file ./deploy/azure_sql_private_endpoint.bicep  --parameters environmentType=Test vmLinuxLoginUser='gary' vmLinuxLoginPassword='g@678219' vmWindowsLoginUser='gary' vmWindowsLoginPassword='g@678219' adminDBLoginName=gary adminDBPassword='H7$vdL&95xKo0Mj' databaseName=slaesfloor 


#Clean up
az group delete --resource-group rg-AzureSQLTest --yes --no-wait

az vm list-skus

az vm image list --publisher MicrosoftWindowsDesktop --offer windows-11 --all