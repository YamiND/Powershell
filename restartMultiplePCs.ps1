Import-Module ActiveDirectory

$computerList = Get-ADComputer -Filter {Name -like "PART-OF-NAME-OR-REGEX-*"}

ForEach($computer in $computerList)
{
    Write-Host $computer.DNSHostName

    # Uncomment the below line to actually reboot the computers by DNS name
    # Restart-Computer -ComputerName $computer.DNSHostName -Force
}