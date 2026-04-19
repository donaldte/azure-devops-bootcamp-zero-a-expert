// ===== PARAMÈTRES =====
@description('Nom de la VM')
param vmName string

@description('Nom d’utilisateur administrateur')
param adminUsername string

@secure()
@description('Mot de passe administrateur')
param adminPassword string

@description('Région')
param location string = resourceGroup().location

@description('Taille de la VM')
param vmSize string = 'Standard_B1s'

// ===== VARIABLES =====
var vnetName = '${vmName}-vnet'
var subnetName = 'default'
var publicIpName = '${vmName}-pip'
var nsgName = '${vmName}-nsg'
var nicName = '${vmName}-nic'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = '10.0.1.0/24'

// ===== RESSOURCES =====

// Groupe de sécurité réseau
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

// IP publique
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-02-01' = {
  name: publicIpName
  location: location
  sku: { name: 'Basic' }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Réseau virtuel
resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [vnetAddressPrefix] }
    subnets: [
      {
        name: subnetName
        properties: { addressPrefix: subnetAddressPrefix }
      }
    ]
  }
}

// Carte réseau
resource nic 'Microsoft.Network/networkInterfaces@2023-02-01' = {
  name: nicName
  location: location
  dependsOn: [ vnet, publicIp, nsg ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: { id: publicIp.id }
          subnet: { id: vnet.properties.subnets[0].id }
        }
      }
    ]
    networkSecurityGroup: { id: nsg.id }
  }
}

// Machine virtuelle
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
  dependsOn: [ nic ]
  properties: {
    hardwareProfile: { vmSize: vmSize }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '22.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        { id: nic.id }
      ]
    }
  }
}

// ===== OUTPUTS =====
output publicIpAddress string = publicIp.properties.ipAddress
output vmId string = vm.id
