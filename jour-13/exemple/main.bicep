param environment string
param location string = resourceGroup().location
param projectName string = 'myapp'

var uniqueString = uniqueString(resourceGroup().id)
var storageName = '${projectName}${environment}stg${uniqueString}'
var vmName = '${projectName}-${environment}-vm'

var storageSku = (environment == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var vmSize = (environment == 'prod') ? 'Standard_D2s_v3' : 'Standard_B1s'

module storage 'modules/storage.bicep' = {
  name: 'storageDeployment'
  params: {
    storageAccountName: storageName
    location: location
    sku: storageSku
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vmDeployment'
  params: {
    vmName: vmName
    location: location
    vmSize: vmSize
    adminUsername: 'azureuser'
    adminPassword: adminPassword
  }
}
