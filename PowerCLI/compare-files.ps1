# Variables
$file = "D:\database.bak"
$remotesystem = server.company.com
$localdrive = g
$useraccount = company\username
$bucket = exmaple-bucket
$pass = "hunter2"
$awsregion = us-gov-west-1
$accesskey = ABCDEFGHIJKLMNOPQRST
$accesskeysecret = ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789

# Script
# Move file
net use $localdrive":" "\\"$remotesystem"\"$localdrive"`$ $pass /user:$useraccount /p:yes

# Check file
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

# Move file to s3
Invoke-Command -ComputerName $remotesystem -ScriptBlock {
	aws configure set region $region --aws_access_key_id $accesskey --aws_secret_access_key $accesskeysecret
	aws s3 cp $localdrive":\"$file s3://$bucket/$file
}
