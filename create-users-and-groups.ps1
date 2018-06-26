Import-Module ActiveDirectory

$csvFile = "users.csv"

New-ADOrganizationalUnit -name "IT"
New-ADOrganizationalUnit -name "Helpdesk" -path "OU=IT,DC=ad,DC=yami,DC=local"
New-ADOrganizationalUnit -name "Training" -path "OU=Helpdesk,OU=IT,DC=ad,DC=yami,DC=local"

New-ADOrganizationalUnit -name "Locations"
New-ADOrganizationalUnit -name "Building-15" -path "OU=Locations,DC=ad,DC=yami,DC=local"
New-ADOrganizationalUnit -name "Users" -path "OU=Building-15,OU=Locations,DC=ad,DC=yami,DC=local"

Import-CSV -delimiter "," $csvFile| foreach {
  New-ADUser -SamAccountName $_.SamAccountName -GivenName $_.GivenName -Surname $_.Surname -Name $_.Name `
             -Path "OU=Users,OU=Building-15,OU=Locations,DC=ad,DC=yami,DC=local" `
             -AccountPassword (ConvertTo-SecureString -AsPlainText $_.Password -Force) -Enabled $true
}

New-ADGroup -Name "SecurePrinting" -SamAccountName "SecurePrinting" -GroupCategory Security -GroupScope Global -DisplayName "Secure Printing Users" -Path "OU=Helpdesk,OU=IT,DC=ad,DC=yami,DC=local"
New-ADGroup -Name "Batch-01" -SamAccountName "Batch-01" -GroupCategory Security -GroupScope Global -DisplayName "CostCenter 123 Users" -Path "OU=Training,OU=Helpdesk,OU=IT,DC=ad,DC=yami,DC=local"
New-ADGroup -Name "Batch-02" -SamAccountName "Batch-02" -GroupCategory Security -GroupScope Global -DisplayName "CostCenter 125 Users" -Path "OU=Training,OU=Helpdesk,OU=IT,DC=ad,DC=yami,DC=local"

Add-ADGroupMember -Identity "SecurePrinting" -Members "Batch-02"
Add-ADGroupMember -Identity "Batch-02" -Members "livy.chen"
Add-ADGroupMember -Identity "Batch-01" -Members "tyler.postma"

