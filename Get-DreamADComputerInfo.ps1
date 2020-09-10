Function Get-DreamADComputerInfo{
    param(
        [int]
        $DuringDay,

        [bool]
        $Enabled

    )
    
    #BaseDate
    
    $date = [DateTime]::Today.AddDays(-$DuringDay).Date

    $filter = {(LastLogonTimeStamp -gt $date) -and (OperatingSystem -notlike 'Windows Server*') -and (OperatingSystem -like 'Windows*') -and (Enabled -eq $Enabled) }
    
    $targetpath = "DC=Dream,DC=Auto"
    
    $computers = Get-ADComputer -searchbase $targetpath -filter $filter  -Properties Name,DistinguishedName,Enabled,Created,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion,IPv4Address,lastLogonTimestamp |Select-Object Name,DistinguishedName,Enabled,Created,IPv4Address,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}}
    
    $computers | Export-Csv -Path ($env:USERPROFILE + "\Desktop\Computerinfo.csv") -Encoding UTF8 -NoTypeInformation
}
