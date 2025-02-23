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

# Step 6: Create Network Security Group (NSG) & Add RDP Rule (Fixed)
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location -Name $nsgName

# Add inbound rule for RDP (TCP 3389)
$nsg = Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name "AllowRDP" -Protocol Tcp `
    -Direction Inbound -Priority 1000 -SourceAddressPrefix "*" -SourcePortRange "*" `
    -DestinationAddressPrefix "*" -DestinationPortRange 3389 -Access Allow

# Apply the NSG configuration
Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg
Write-Host "Network Security Group Created: $nsgName with RDP rule"

# Step 7: Create Network Interface (NIC) (Fixed)
$nic = New-AzNetworkInterface -ResourceGroupName $resourceGroup -Location $location `
    -Name $nicName -SubnetId $subnet.Id -PublicIpAddressId $publicIp.Id -NetworkSecurityGroupId $nsg.Id
Write-Host "Network Interface Created: $nicName"

# Step 8: Configure VM
$cred = New-Object -TypeName System.Management.Automation.PSCredential `
    -ArgumentList $adminUsername, (ConvertTo-SecureString -String $adminPassword -AsPlainText -Force)

$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize | `
    Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzVMSourceImage -PublisherName $imagePublisher -Offer $imageOffer -Skus $imageSku -Version "latest" | `
    Add-AzVMNetworkInterface -Id $nic.Id | `
    Set-AzVMOSDisk -Name $osDiskName -CreateOption FromImage
Write-Host "VM Configuration Created"