################################
# Get ESX host IPs using PowerCLI
################################
# Get all ESX host IPs
# Run using PowerCLI from a windows jumpbox
# Connect to vCenter servers
Set-PowerCLIConfiguration -ProxyPolicy NoProxy -Confirm:$false -scope session
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false -scope session
connect-viserver 10.1.0.10
connect-viserver 10.2.0.10
connect-viserver 10.3.0.10
connect-viserver 10.4.0.10
connect-viserver 10.5.0.10
connect-viserver 10.6.0.10
connect-viserver 10.7.0.10
# Collect ESX IPs
(Get-VMHost | Get-VMHostNetwork).consolenic.ip | out-file ~\Desktop\esxips.txt
