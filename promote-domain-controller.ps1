if ((gwmi win32_computersystem).partofdomain -eq $false) {

  Write-Host 'Promoting domain controller'
  # Set administrator password
  $computerName = $env:COMPUTERNAME
  $adminPassword = "vagrant"
  $adminUser = [ADSI] "WinNT://$computerName/Administrator,User"
  $adminUser.SetPassword($adminPassword)

  $PlainPassword = "vagrant" # Change this or use Get-Credential...
  $SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force

  # Windows Server 2019
  Install-WindowsFeature AD-Domain-Services
  Import-Module ADDSDeployment
  Install-ADDSDomainController `
   -InstallDns:$true `
   -DomainName 'ad.yami.local' `
   -Credential (New-Object System.Management.Automation.PSCredential("ad.yami.local\Administrator",$SecurePassword)) `
   -SafeModeAdministratorPassword $SecurePassword `
   -Confirm:$false `
   -LogPath "C:\Windows\NTDS" `
   -NoRebootOnCompletion:$true `
   -SysvolPath "C:\Windows\SYSVOL" `
   -Force:$true  
}
