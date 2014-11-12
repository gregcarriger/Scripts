# Connect to vCenters
# By Greg Carriger
#
Set-PowerCLIConfiguration -ProxyPolicy NoProxy -Confirm:$false
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false
connect-viserver 1.1.1.1
connect-viserver 1.1.1.2
connect-viserver 1.1.1.3
connect-viserver 1.1.1.4
connect-viserver 1.1.1.5
connect-viserver 1.1.1.6
connect-viserver 1.1.1.7
 
# To disconnect from a vCenter server
# disconnect-viserver 1.1.1.1
# To disconnect from all vCenter servers
# disconnect-viserver *
# Check to see what vCenter server you are connected to
$global:DefaultVIServer