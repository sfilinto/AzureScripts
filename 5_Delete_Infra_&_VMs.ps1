$RGname = "CONTOSO"

######################### Get resources
Find-AzureRmResource -ResourceGroupName $RGname | fl name, resourcetype
Find-AzureRmResource -ResourceGroupName $RGname -ResourceNameContains server01 | fl name, resourcetype

######################### Delete all resources in RG
##### Delete VMs
Get-AzureRmResource -ResourceGroupName $RGname -ResourceType Microsoft.Compute/virtualMachines | Remove-AzureRmVM -force
##### Delete Disks
Get-AzureRmResource -ResourceGroupName $RGname -ResourceType Microsoft.Compute/disks | Remove-AzureRmDisk -force
##### Delete NIC
Get-AzureRmResource -ResourceGroupName $RGname -ResourceType Microsoft.Network/networkInterfaces | Remove-AzureRmNetworkInterface -force
##### Delete Public IP
Get-AzureRmResource -ResourceGroupName $RGname -ResourceType Microsoft.Network/publicIPAddresses | Remove-AzureRmPublicIpAddress -force
#### Delete NSG
Get-AzureRmResource -ResourceGroupName $RGname -ResourceType Microsoft.Network/networkSecurityGroups | Remove-AzureRmNetworkSecurityGroup -Force
#### Delete Virtual Networks
Get-AzureRmResource -ResourceGroupName $RGname -ResourceType Microsoft.Network/virtualNetworks | Remove-AzureRmVirtualNetwork -Force

######################### Delete Entire RG
Get-AzureRmResourceGroup $RGname | Remove-AzureRmResourceGroup
