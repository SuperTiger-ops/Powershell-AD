$groupName = ""

$computers = import-csv -Path ($env:USERPROFILE + "\Desktop\Computers.csv")


Function Get-DreamResGroupname([string]$gName,[System.Collections.Generic.HashSet[String]]$groups){
    
    [void]$groups.Add((Get-ADGroup -Identity $gName).DistinguishedName)

    $members = Get-ADGroup -Identity $gName -Properties Members | Select-Object -ExpandProperty Members
    
    foreach($item in $members){
        $type = (Get-ADObject -Identity $item).ObjectClass
        if($type -eq "Group"){
            Write-Host $item
            [void]$groups.Add($item)
            Get-GeelyResGroupname -gName $item -groups $groups
        }
    }
}


$groups = New-Object System.Collections.Generic.HashSet[String]

Get-DreamResGroupname -gName $groupName -groups $groups

Foreach($temp in $computers.name){
    $cname = $temp + "$"

    foreach($item in $groups){        
        try{
            if((Get-ADComputer -Identity $cname -Properties memberof | Select-Object memberof).memberof -contains $item ){
                Remove-ADGroupMember -Identity $item -Members $cname -Confirm:$false
                Write-Host $temp Removing OK From $item 
            }else{
                Write-Host $temp Not Find in $item
            }
        }
        catch{
            Write-Host $Error[0]
        }
    }

}
