########## variables
$source_pst_location = "\\location\of\pst\files"
$azcopy_log_directory = "C:\temp\"
$blob_service_sas_URL = "https://1324567890123456789.blob.ingestion.blobl4.protection.office365.com/ingestiondata?sv=2015-04-05&sr=c&si=IngestionSasForAzCopy123456789123456789123&sig=abcdefghijklmnopqrstuvwxyz=2021-11-07"
$azcopy_exe = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe"

# Fix variable
$source_pst_location_fixed = $source_pst_location.replace('\','\\')

# Test if ready to start
if ($(test-path $source_pst_location) -EQ "True" -And $(test-path $azcopy_log_directory) -EQ "True" -And $(test-path $azcopy_exe) -EQ "True")
{

# Get unprocessed PST files and data for the import CSV
$pst_files = Get-ChildItem -path $source_pst_location -Recurse -Filter "*.pst" | Select-Object name,fullname,length
$pst_files | Add-Member -NotePropertyName TargetRootFolder -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName Status -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName NewFullName -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName Mailbox -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName Workload -NotePropertyValue Exchange
$pst_files | Add-Member -NotePropertyName FilePath -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName IsArchive -NotePropertyValue TRUE
$pst_files | Add-Member -NotePropertyName ContentCodePage -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName SPFileContainer -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName SPManifestContainer -NotePropertyValue $null
$pst_files | Add-Member -NotePropertyName SPSiteUrl -NotePropertyValue $null
$pst_files | ForEach-Object {
	$_.{TargetRootFolder} = $_.{FullName} -replace $source_pst_location_fixed , ""
	$_.{TargetRootFolder} = $_.{TargetRootFolder}.replace('\','-')
	$_.{TargetRootFolder} = $_.{TargetRootFolder}
	$_.{NewFullName} = $_.{FullName} -replace $_.{Name} , $_.{TargetRootFolder}
	$_.Mailbox = (get-aduser -Identity (get-item $_.FullName).directory.name).UserPrincipalName
	$_.{Name} = $_.{TargetRootFolder}
}
write-output "PSTs that are not in a folder referencing a User ID"
$pst_files | Where-Object mailbox -eq $null | select-object FullName,Mailbox
}
