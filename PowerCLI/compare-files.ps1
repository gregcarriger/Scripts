# Compare transfered files
$file = "D:\database.bak"
$remotesystem = server.company.com

# Script
$filehash = (Get-FileHash $file).hash
$filelength = (Get-item $file).Length
Invoke-Command -ComputerName $remotesystem -ScriptBlock {
	$remotefilehash = (Get-FileHash $file).hash
	$remotefilelength = (Get-item $file).Length
	Write-Output "Do the file hashes match?"
	:filehash -eq $remotefilehash
	Write-Output "Do the file lengths match?"
	:filelength -eq $remotefilelength
}
