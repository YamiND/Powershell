$interfaceIndex = (Get-NetIPAddress | Where-Object { $_.IPAddress -match "10.0.*.*" }).InterfaceIndex

Get-NetAdapter -ifIndex $interfaceIndex | Disable-NetAdapter -Confirm:$false