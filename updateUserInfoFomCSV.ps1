Import-Module ActiveDirectory

# CSV Uses this format: Firstname,LastName,Username 
$userList = import-csv “C:\Location-of-CSV”

ForEach ($user in $userList)
{
    $firstName = $($user.Firstname)
    $lastName = $($user.Lastname)
    $username = $($user.Username)

    $displayName = "$firstName $lastName"

    Write-host $firstName, $lastName, $username, $displayName

    # Uncomment this to make changes in AD after verifiying everything looks good
    # Set-ADUser -Identity $username -GivenName $firstName -Surname $lastName -DisplayName $displayName
}