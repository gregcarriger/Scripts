# Compare transfered files
$file = "D:\database.bak"
$remotesystem = server.company.com

# Script
$filehash = Get-FileHash $file
$filelength = Get-item $file | Select-Object Length
Invoke-Command -ComputerName $remotesystem -ScriptBlock {
	$remotefilehash = Get-FileHash $file
	$remotefilelength = Get-item $file | Select-Object Length
	Write-Output "Do the file hashes match?"
	:filehash -eq $remotefilehash
	Write-Output "Do the file lengths match?"
	:filelength -eq $remotefilelength
}
