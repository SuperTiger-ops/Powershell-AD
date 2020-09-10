#Author: Felix
#Version: 1.0

Function Migration-DreamADGroupMemebers{
    
    Param(
       [string]$desgroupname,
       [string]$sourcegroupname     
    )

    $desmembers = Get-ADGroupMember -Identity $desgroupname
    Write-Host $desmembers.count

    $sourcemembers = Get-ADGroupMember -Identity $sourcegroupname
    Write-Host $sourcemembers.count

    foreach($item in $sourcemembers){
        try{
            Add-ADGroupMember -Identity $desgroupname -Members $item.SamAccountName
        }
        catch{
            Write-Host $Error[0]
        }
    }

    $desEndmembers = Get-ADGroupMember -Identity $desgroupname
    Write-Host $desEndmembers.count
}
