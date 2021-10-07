$userlist = @('user001','user002','user003')
foreach ($user in $userlist){Get-ADUser $user -Properties nationality-example |Select-Object nationality-example}
