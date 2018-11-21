# Check how ancient your bios is
Get-VMHost | Select-Object name,version,build,parent,model,Maxevcmode,{$_.ExtensionData.hardware.biosinfo.biosversion},{$_.ExtensionData.hardware.biosinfo.ReleaseDate} | export-csv ~\Desktop\bios.csv
