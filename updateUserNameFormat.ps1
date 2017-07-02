Import-Module ActiveDirectory

$allUsers = Get-ADUser -Filter * -Properties cn,displayName -SearchBase "OU=OU-LOCATION,dc=DC-NAME,dc=TLD"

foreach ( $u in $allUsers | Where-Object { ($_.givenName) -and ($_.surName) } )
{
    $fn = $u.givenName.Trim()
    $ln = $u.surName.Trim()
  
    Write-Host $fn $ln

    # Uncomment below to update the user's name information in AD
    # Set-ADUser -Identity $u -DisplayName "$fn $ln" -GivenName "$fn" -SurName "$ln" -PassThru |
    # Rename-ADObject -NewName "$fn $ln"
}
