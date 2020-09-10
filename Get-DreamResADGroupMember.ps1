#Author: Felix
#Version: 1.0

$groups = ("")

Function Get-DreamRecADGroupmembers($groupName){
    foreach($item in $groupName){
        $members = Get-ADGroup -Identity $item -Properties Members | Select-Object -ExpandProperty Members    
        foreach($temp in $members){
            try{
                $type = (Get-ADObject -Identity $temp).ObjectClass
                if($type -eq "computer")
                {
                    $computer =  get-adcomputer -Identity $temp -Properties Created,OperatingSystem,lastLogonTimestamp,ipv4address | Where-Object {$_.enabled -eq $true}|Select-Object Name,Enabled,Created,OperatingSystem,lastLogonTimestamp,ipv4address,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}}
                    $computer | Add-Member -Name "App" -Value $item -MemberType NoteProperty
                    $Computer | Export-Csv -Path ($env:USERPROFILE + "\Desktop\ComputerMembers.csv") -NoTypeInformation -Encoding UTF8 -Append
                }
                elseif($type -eq "Group")
                {
                    get-DreamRecADGroupmembers -groupName $temp
                }
                elseif($type -eq "User")
                {
                    $user = Get-ADUser -Identity $temp -Properties Created,company,department,lastLogonTimestamp | Where-Object {$_.enabled -eq $true} | Select-Object Name,company,department,Created,@{n="lastLogonDate";e={[datetime]::FromFileTime($_.lastLogonTimestamp)}}
                    $user | Export-Csv -Path ($env:USERPROFILE + "\Desktop\UserMembers.csv") -NoTypeInformation -Encoding UTF8 -Append
                }
                else{
                    Write-Host $type
                }
            }
            catch{
                Write-Host $Error[0]
            }
        }
    
    }

}

Get-DreamRecADGroupmembers -GroupName $groups
