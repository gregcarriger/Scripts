# restart vpxa
# 
# Checks for hosts with reported CPU usage of zero which most likely means their management agent is in an error state.
$baddies = Get-VMHost | ? {$_.CpuUsageMhz -eq 0}
$baddies | Get-VMHostService | ? {$_.Key -eq 'vpxa' } | Restart-VMHostService