Import-Module ActiveDirectory

$userList = Get-ADUser -SearchBase "OU=OU-LOCATION,dc=DC-NAME,dc=TLD"  -filter * -Properties * | Where {$_.GivenName -eq $Null -OR $_.Surname -eq $Null -OR $_.Name -eq $Null} | select samAccountName | Sort-Object SamAccountName

ForEach($user in $userList)
{
    Write-Host $user.SamAccountName
}