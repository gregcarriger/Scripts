<#
.Synopsis
   Rename and upload PSTs to Exchange Online
.DESCRIPTION
   Rename and upload PSTs to Exchange Online using https://docs.microsoft.com/en-us/microsoft-365/compliance/use-network-upload-to-import-pst-files?view=o365-worldwide#step-1-copy-the-sas-url-and-install-azcopy
.EXAMPLE
   Update the variables source_pst_location, azcopy_log_directory, and blob_service_sas_URL and then run script.
.INPUTS
   None
.OUTPUTS
   .csv file for use with Exchange Online compliance center.
.NOTES
    Author     : Greg Carriger
    Version    : 1.0.0.0 Initial Build  
	Script assumes the PST files are in a folder that is named with the active directory user ID.
	You must have the Active Directory RSAT installed.
.COMPONENT
   None
.ROLE
   None
.FUNCTIONALITY
   Rename and upload PSTs to Exchange Online
#>

########## Prod variables
$source_pst_location = "\\company\shared\drive\PST-folder\"
$azcopy_log_directory = "C:\temp\"
$blob_service_sas_URL = "https://abcdefghijklmnopqrstuvwxyz.blob.ingestion.blobl4.protection.office365.us/ingestiondata?sv=2015-04-05&sr=c&si=IngestionSasForAzCopy1234567890123456789&sig=12345678901234567890123456789&se=2021-11-04T18"
$azcopy_exe = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy\AzCopy.exe"

# Fix variable
$source_pst_location_fixed = $source_pst_location.replace('\','\\')

# Test if ready to start
if ($(test-path $source_pst_location) -EQ "True" -And $(test-path $azcopy_log_directory) -EQ "True" -And $(test-path $azcopy_exe) -EQ "True")
{
write-output "Does source_pst_location exist?"
test-path $source_pst_location
write-output "Does azcopy_log_directory exist?"
test-path $azcopy_log_directory
write-output "Does azcopy_exe exist?"
test-path $azcopy_exe
write-output "Use CTRL+C to stop the script and make sure files and folders exist."
pause
}

# Get unprocessed PST files and data for the import CSV
$pst_files = Get-ChildItem -path $source_pst_location -Recurse -Filter "*.pst" | Select-Object name,fullname,length#,LastAccessTimeUtc
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
	$_.{Name} = $_.{TargetRootFolder}
	$_.{NewFullName} = $_.{FullName} -replace $_.{Name} , $_.{TargetRootFolder}
	$_.Mailbox = (get-aduser -Identity (get-item $_.FullName).directory.name).UserPrincipalName

	# rename the big pst files
	If ($_.Length -gt 19000000000)
		{
		Rename-Item -Path $_.FullName -NewName "$($_.Name).toobig"
		$_.Status = "Renamed .big"
	}
	Elseif ($_.{FullName} -replace $source_pst_location_fixed , "" )
		{
		# add folder name to pst files
		Rename-Item -Path $_.FullName -NewName $_.TargetRootFolder
		$_.Status = "Appended directory name to filename"
	}
	Else
		{
	}
}

# generate .csv needed for exchange online import.
$pst_files | Select-Object Workload,FilePath,Name,Mailbox,IsArchive,TargetRootFolder,ContentCodePage,SPFileContainer,SPManifestContainer,SPSiteUrl | export-csv -NoTypeInformation $($azcopy_log_directory)PstImportMappingFile.csv
write-output "Please use $($azcopy_log_directory)PstImportMappingFile.csv for the Exchange Online pst import."

# upload .pst files
$pst_files | ForEach-Object {
	Invoke-Item $azcopy_exe "/Source:$($_.Name) /Dest:$($blob_service_sas_URL) /Pattern:$($_.name) /v:$(($azcopy_log_directory)+$($_.Name)+"-azcopy.log") /y"
	Rename-Item -Path $_.FullName -NewName "$($_.Name).uploaded"
}