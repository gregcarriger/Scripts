### Your variables

$DevKV = somename
$DevKVCert = somename
$TestKV = somename
$TestKVCert = somename
$BetaKV = somename
$BetaKVCert = somename
$ProdKV = somename
$ProdKVCert = somename

### Connect to Azure

Connect-AzAccount

### Get Public cert thumbprints

$devthumb = (Get-AzKeyVaultCertificate -VaultName $DevKV -Name $DevKVCert).Thumbprint
$testthumb = (Get-AzKeyVaultCertificate -VaultName $TestKV -Name $TestKVCert).Thumbprint
$betathumb = (Get-AzKeyVaultCertificate -VaultName $BetaKV -Name $BetaKVCert).Thumbprint
$prodthumb = (Get-AzKeyVaultCertificate -VaultName $ProdKV -Name $ProdKVCert).Thumbprint

### Check test apps against public certs

$AzAppCerts = @()
$AzApps = Get-AzWebApp | Select-Object Name
foreach ($AzApp in $AzApps)
{
	$AzData = New-Object -TypeName PSObject
	Add-Member -InputObject $AzData -Type NoteProperty -Name Parent -Value $AzApp.name
	$Thumb = (Get-AzWebApp -name $AzApp.name | Get-AzWebAppSSLBinding).Syncroot.Thumbprint
	Add-Member -InputObject $AzData -Type NoteProperty -Name Thumbprint -Value $Thumb
	$AzAppCerts += $AzData
}
$AzAppCerts

### Find apps that need cert updates

$AzAppCerts | Where-Object Thumbprint -eq $devthumb | select-object parent
$AzAppCerts | Where-Object Thumbprint -eq $testthumb | select-object parent
$AzAppCerts | Where-Object Thumbprint -eq $betathumb | select-object parent
$AzAppCerts | Where-Object Thumbprint -eq $prodthumb | select-object parent
