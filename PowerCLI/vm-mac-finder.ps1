# MAC finder
get-vm | Get-NetworkAdapter | Where-Object MacAddress -eq "00:50:56:00:00:00" | Select-Object Parent,Name,MacAddress
