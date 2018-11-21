# Evacuate DataStore
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
