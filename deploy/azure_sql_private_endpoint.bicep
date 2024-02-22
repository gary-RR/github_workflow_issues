param location string=resourceGroup().location

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

param vnetId string
param frontendSubnet object
param backendSubnet object


output vnetId string = vnetId
output frontendSubnet object = frontendSubnet
output backendSubnet object = backendSubnet



