#Restart-Service –name "ADWS"

Import-Module ActiveDirectory

Set-ADDefaultDomainPasswordPolicy -Identity 'ad.yami.local' -ComplexityEnabled:$false 