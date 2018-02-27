# Connect to vCenters
# v1.0
# by Greg
# Suppress cert errors, allow connection to multiple vCenters
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope AllUsers -confirm:$false >$null 2>&1
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false >$null 2>&1
# Connect to all 4 vCenters
Write-Host "Enter vSphere username" -ForegroundColor Yellow -BackgroundColor Black
$User = Read-Host -Prompt 'Username[your-user-id]'
if ([string]::IsNullOrWhiteSpace($User))
{
$User = 'your-user-id'
}
$Pass = Read-Host -assecurestring "Password[]"
$Pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Pass))
Connect-VIServer -Server vSphere1.example.com -Protocol https -User $User -Password $Pass
Connect-VIServer -Server vSphere2.example.com -Protocol https -User $User -Password $Pass
Connect-VIServer -Server vSphere3.example.com -Protocol https -User $User -Password $Pass
Connect-VIServer -Server vSphere4.example.com -Protocol https -User $User -Password $Pass
Write-Host "Clearing password variable" -ForegroundColor Yellow -BackgroundColor Black
$Pass = "hunter2"
Write-Host connected to $global:DefaultVIServers
