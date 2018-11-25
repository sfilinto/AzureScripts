# The below commands will install & Import the modules needed. Recomended to run each command seperatelly. 
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Install-Module -Name PowerShellGet -Force
Install-Module -Name MSOnline
Install-Module -Name AzureAD
Install-Module -Name AzureRM -AllowClobber

Import-Module -Name PowerShellGet
Import-Module -Name MSOnline
Import-Module -Name AzureAD
Import-Module -Name AzureRM

# Verify versions of module
$PSVersionTable.PSVersion # Windows Management Framework
Get-Module -Name PowerShellGet -ListAvailable | Select-Object -Property Name,Version,Path
Get-Module -Name MSOnline -ListAvailable | Select-Object -Property Name,Version,Path
Get-Module -Name AzureAD -ListAvailable | Select-Object -Property Name,Version,Path
Get-Module -Name AzureRM -ListAvailable | Select-Object -Property Name,Version,Path