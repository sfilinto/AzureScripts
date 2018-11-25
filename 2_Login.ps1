Login-AzureRmAccount




#Optimize    ##############################
Save-AzureRmContext –Path C:\bin\azurecreds.json
Import-AzureRmContext –Path C:\bin\azurecreds.json | out-null


Get-AzureRmVM -Status |sort-object PowerState