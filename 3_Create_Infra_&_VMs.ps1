##############################################################Define Infrastructure Variables
$RGname = "CONTOSO"
$location = "southeastasia"
$vnetworkname = "CONTOSO_network"
$vSubnetname = "subnet-1"
$netaddr = "192.168.0.0/16" #Virtual Network IP Range
$subnetr = "192.168.1.0/24" #Subnet IP Range
$NSGname = "CONTOSO_NSG"
$tz = "Singapore Standard Time"
$username = "contosoadmin"
$password = ConvertTo-SecureString "Password123#" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)
##############################################################Create Infrastructure
# Create a Resource Group
New-AzureRmResourceGroup $RGname -Location $location

# Define / Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $vSubnetname -AddressPrefix $subnetr

# Create a Virtual Network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $RGname -Location $location -Name $vnetworkname -AddressPrefix $netaddr -Subnet $subnetConfig

# Define / Create an inbound Network Security Group Rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name RDPallow  -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

# Create a Network Security Group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $RGname -Location $location -Name $NSGname -SecurityRules $nsgRuleRDP
##############################################################Define VM Variables
$VMname = "server01"            # Server Hostname
$dnsPrefix = "lab01-" + $VMname # This name is used for public access only
$VMsize = "Basic_A2"
$skuname = "2016-Datacenter"
$rdpfile = 'c:\bin\' + $VMname + '.rdp'
$publicipname = $VMname + "_Public_IP"
$Nicname = $VMname + "_NIC"
##############################################################Create a VM
# Create a Public IP Address
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $RGname -Location $location -AllocationMethod Dynamic -IdleTimeoutInMinutes 4 -Name $publicipname -IpAddressVersion IPv4 -DomainNameLabel $dnsPrefix

# Create a Virtual Network Card and associate it with the Public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name $Nicname -ResourceGroupName $RGname -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

# Create a Virtual Machine Configuration
$vmConfig = New-AzureRmVMConfig -VMName $VMname -VMSize $VMsize | Set-AzureRmVMOperatingSystem -Windows -ComputerName $VMname -Credential $cred -TimeZone $tz | Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus $skuname -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id | Set-AzureRmVMBootDiagnostics -Disable

# Create a virtual machine
New-AzureRmVM -ResourceGroupName $RGname -Location $location -VM $vmConfig

# Create an .RDP file for connecting to the VM
Get-AzureRmRemoteDesktopFile -ResourceGroupName $RGname -Name $VMname -LocalPath $rdpfile -Launch

# Print Server Hostname
write-host ("VM is Created, The Public Host Name is:        " + $dnsPrefix) -ForegroundColor Red
##############################################################
### supporting commands
Get-AzureRmVMImageSku -Location $location -PublisherName MicrosoftWindowsServer -Offer WindowsServer # List all available SKUs
Get-AzureRmVMSize -ResourceGroupName $RGname -VMName $VMname                                         # List all available sizes
