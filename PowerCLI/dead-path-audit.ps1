# Dead Path Audit
# By Greg Carriger
# 
 Get-VMHost | % {
     $Server = $_
     ($Server | Get-View).config.storagedevice.multipathinfo.Lun | % { $_.Path } | ? { $_.PathState -like "Dead" } | select Name, PathState, LunName |
     Add-Member -pass NoteProperty  Server $Server | Select Server, Name, PathStat
     } | Export-Csv -Path %userprofile%\desktop\deadpath.csv -NoTypeInformation
#
# This script only checks a specific cluster
#
$cluster = "cluster-name"
Get-Cluster -Name $cluster | Get-VMHost | % {
     $Server = $_
     ($Server | Get-View).config.storagedevice.multipathinfo.Lun | % { $_.Path } | ? { $_.PathState -like "Dead" } | select Name, PathState, LunName |
     Add-Member -pass NoteProperty  Server $Server | Select Server, Name, PathStat
     } | Export-Csv -Path %userprofile%\desktop\cluster-deadpath.csv -NoTypeInformation