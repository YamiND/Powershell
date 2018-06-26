$subnet = "192.168.1.120" -replace "\.\d+$", ""

if ((gwmi win32_computersystem).partofdomain -eq $false) {

  Write-Host 'Creating domain controller'
  # Set administrator password
  $computerName = $env:COMPUTERNAME
  $adminPassword = "vagrant"
  $adminUser = [ADSI] "WinNT://$computerName/Administrator,User"
  $adminUser.SetPassword($adminPassword)

  $PlainPassword = "vagrant" # "This was used in conjunction with vagrant; you should change this....."
  $SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force # Also should be using Get-Credential instead

  # Windows Server 2019
  Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
  Import-Module ADDSDeployment
  Install-ADDSForest `
    -SafeModeAdministratorPassword $SecurePassword `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Default" `
    -DomainName "ad.yami.local" ` # Yes I know .local is bad, but I don't want to buy a domain name at this time...
    -DomainNetbiosName "AD" `
    -ForestMode "Default" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

  $newDNSServers = "8.8.8.8", "127.0.0.1"
  $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPAddress -And ($_.IPAddress).StartsWith($subnet) }
  if ($adapters) {
    Write-Host Setting DNS
    $adapters | ForEach-Object {$_.SetDNSServerSearchOrder($newDNSServers)}
  }
}
