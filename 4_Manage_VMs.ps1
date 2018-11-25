$RGname = "CONTOSO"

# Get Status of VMs
Get-AzureRmVM -ResourceGroupName $RGname -Status |sort-object PowerState

# Start VM
Start-AzureRmVM -ResourceGroupName $RGname -Name dc01

# Stop VM
Stop-AzureRmVM -ResourceGroupName $RGname -Name dc01 -Force

# Re-Size VM ###########################################################################################################
$RGname = "CONTOSO"
$VMname = "server01"
$Sizename = "Basic_A2" # Basic_A0 Basic_A1 Basic_A2

$vm = Get-AzureRmVM -ResourceGroupName $RGname -VMName $VMname
#$ops = Get-AzureRmVMSize -ResourceGroupName $RGname -VMName $VMname | select Name # List all sizes
write-host ("Host Name        : " + $vm.Name) -ForegroundColor Red
write-host ("Current Config   : " + $vm.HardwareProfile.VmSize) -ForegroundColor Red
write-host ("Proposed Change  : " + $Sizename) -ForegroundColor Green
#write-host ("Available Options: " ) -ForegroundColor Red
#$ops

$vm.HardwareProfile.VmSize = $Sizename
Update-AzureRmVM -VM $vm -ResourceGroupName $RGname
write-host ("Host Name        : " + $vm.Name) -ForegroundColor Green
write-host ("After Change     : " + $vm.HardwareProfile.VmSize) -ForegroundColor Green

# List all available VM sizes
# Get-AzureRmVMSize -ResourceGroupName $RGname -VMName $VMname     


