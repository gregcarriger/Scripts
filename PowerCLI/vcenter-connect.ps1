# Connect to vCenters
# v1.0
# by Greg Carriger
# Suppress cert errors, allow connection to multiple vCenters
Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope AllUsers -confirm:$false >$null 2>&1
Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false >$null 2>&1
# Connect to all 4 vCenters
$vcenterservers = "vc1.example.com", "vc2.example.com", "vc3.example.com", "vc4.example.com"
Write-Host "Enter vSphere username" -ForegroundColor Yellow -BackgroundColor Black
$User = Read-Host -Prompt 'Username[some.person]'
if ([string]::IsNullOrWhiteSpace($User))
{
$User = 'some.person'
}
$Pass = Read-Host -assecurestring "Password[]"
$Pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Pass))
Connect-VIServer -Server $vcenterservers -Protocol https -User $User -Password $Pass
Write-Host "Clearing password variable" -ForegroundColor Yellow -BackgroundColor Black
$Pass = "hunter2"
Write-Host connected to $global:DefaultVIServers
