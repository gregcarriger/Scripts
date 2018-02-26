Get-VM | Where-Object -FilterScript { $_.Guest.Nics.IPAddress -contains "1.2.3.4" }
