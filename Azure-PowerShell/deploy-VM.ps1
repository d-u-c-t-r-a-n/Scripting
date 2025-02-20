# Step 1: Connect to Azure
Connect-AzAccount -TenantId <TenantId>

# Step 2: Define Variables
$resourceGroup = "ResrcGroup"
$location = "CanadaCentral"
$vmName = "MyVM"
$adminUsername = "admin"
$adminPassword = "admin"
$vnetName = "VNetName"
$subnetName = "SubnetName"
$publicIpName = "PublicIPName"
$nsgName = "NSGName"
$nicName = "NICName"
$vmSize = "Standard_B2s"
$imagePublisher = "MicrosoftWindowsServer"
$imageOffer = "WindowsServer"
$imageSku = "2022-datacenter"
$osDiskName = "$vmName-OSDisk"

# Step 3: Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location
Write-Host "Resource Group Created: $resourceGroup"

# Step 4: Create Virtual Network & Subnet (Fixed)
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroup -Location $location -Name $vnetName -AddressPrefix "10.0.0.0/16"

$vnet = Set-AzVirtualNetwork -VirtualNetwork $vnet

# Add Subnet to the Virtual Network
$subnet = Add-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix "10.0.1.0/24" -VirtualNetwork $vnet
$vnet | Set-AzVirtualNetwork

# Retrieve the correct subnet object
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork (Get-AzVirtualNetwork -ResourceGroupName $resourceGroup -Name $vnetName)
Write-Host "Virtual Network and Subnet Created: $vnetName, $subnetName"

# Step 5: Create Public IP
$publicIp = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location -Name $publicIpName -AllocationMethod Static
Write-Host "Public IP Created: $publicIpName"