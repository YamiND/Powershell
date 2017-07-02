Import-Module ActiveDirectory

$userList = Get-ADUser -SearchBase "OU=OU-LOCATION,dc=DC-NAME,dc=TLD"  -filter * -Properties * | ? {$_.Description -eq "CURRENT-DESCRIPTION"} | Select-Object SamAccountName | Sort-Object SamAccountName

ForEach($user in $userList)
{
    Write-Host $user.SamAccountName

    # Uncomment this to make the changes in AD
    # Set-ADUser $user.SamAccountName -Description "NEW-DESCRIPTION"
}