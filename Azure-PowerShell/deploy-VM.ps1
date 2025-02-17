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
