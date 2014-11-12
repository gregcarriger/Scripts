# Storage vMotion
# By Greg Carriger
# 
# When you work in an environment that has too many datastores to list in the GUI, it's time to bust out PowerCLI.
# This is just an example. Putting this in a ps1 file will let you serially execute a bunch of svMotions.
# Replace vm-name, Hard disk # and us01a01a05a2
Get-HardDisk -vm vm-name | Where {$_.Name -eq "Hard disk 2"} | % {Set-HardDisk -HardDisk $_ -Datastore us01a01a05a2 -Confirm:$false}
Get-HardDisk -vm vm-name | Where {$_.Name -eq "Hard disk 3"} | % {Set-HardDisk -HardDisk $_ -Datastore us01a01a05a2 -Confirm:$false}
Get-HardDisk -vm vm-name | Where {$_.Name -eq "Hard disk 4"} | % {Set-HardDisk -HardDisk $_ -Datastore us01a01a05a2 -Confirm:$false}