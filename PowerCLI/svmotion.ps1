# Evacuate DataStore
# If you svmotion everything at once, it tries to move EVERY vmdk to the least used datastore because svmotions execute (8x) concurrently by default. This fills up one datastore.
#==========
# Variables
#==========
$EvacuatingDataStore = "old-busted-datastore01"
$DestinationDataStoreCluster = "DatastoreCluster01"
#==========
# Script
#==========
Get-Datastore $EvacuatingDataStore | get-vm | ForEach-Object {
	$FreeDataStore = Get-DatastoreCluster -name $DestinationDataStoreCluster | Get-Datastore | Sort-Object -Property FreeSpaceGB -Descending | Select-Object -First 1
	move-vm -vm  $_.Name -Datastore $FreeDataStore
	Get-DatastoreCluster -name $DestinationDataStoreCluster | Get-Datastore | sort-object FreeSpaceGB -Descending | select name,FreeSpaceGB | ft
	$VMsleft = (Get-Datastore $EvacuatingDataStore | get-vm | measure-object).count
	Write-Output "VMs left $VMsleft"
}
