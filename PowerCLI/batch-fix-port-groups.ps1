# Dump out port-group info from vSphere
#
get-vm customer-number* | Get-NetworkAdapter | export-csv %userprofile%\desktop\customer-nics.csv
#
# Compare this data against CMDB
# Command I compiled in excel to batch fix port-groups. I just used a ton of CONCATENATEs. Way too much work to do manually.
#
get-vm customer-number1 | get-networkadapter | Set-NetworkAdapter -name 'Network adapter 1' -NetworkName new-port-group-1 -Confirm:$false
get-vm customer-number1 | get-networkadapter | Set-NetworkAdapter -name 'Network adapter 2' -NetworkName new-port-group-2 -Confirm:$false