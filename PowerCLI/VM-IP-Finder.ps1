Get-VM | Where-Object -FilterScript { $_.Guest.Nics.IPAddress -eq "1.2.3.4" }
