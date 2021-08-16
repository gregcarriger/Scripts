<#
.SYNOPSIS
    Checks for AWS AD Group Membership
.DESCRIPTION
    Checks for the name AWS in AD Groups for 3 account types.
.EXAMPLE
    PS C:\> AWSGroupCheck.ps1 s1234567
    This checks the AD User s1234567, p1234567, and t1234567 for AWS Group membership.
.INPUTS
    Inputs
        account name
.OUTPUTS
    Output
        AWS group memberships
.NOTES
    General notes
#>
$SpecificUser=$args[0]
if ($null -eq $args[0]){
    $SpecificUser = $env:USERNAME
}
else {
    $SpecificUser = $args[0]
}
Write-Output "`nAWS Groups for $SpecificUser"
(Get-ADPrincipalGroupMembership ($SpecificUser) | Where-Object {$_.name -like "*AWS*"} | Sort-Object name).name
Write-Output "`nAWS Groups for $($SpecificUser -replace "s","p")"
(Get-ADPrincipalGroupMembership ($SpecificUser -replace "s","p") | Where-Object {$_.name -like "*AWS*"} | Sort-Object name).name
Write-Output "`nAWS Groups for $($SpecificUser -replace "s","t")"
(Get-ADPrincipalGroupMembership ($SpecificUser -replace "s","t") | Where-Object {$_.name -like "*AWS*"} | Sort-Object name).name
