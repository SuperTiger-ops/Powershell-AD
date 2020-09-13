#Author: Felix
#Version: 1.0

Function Migration-DreamADGroupMemebers{
    
    Param(
       [string]$desgroupname,
       [string]$sourcegroupname     
    )

    if($desgroupname -and $sourcegroupname){

        $desmembers = Get-ADGroup -Identity $desgroupname -Properties members | Select-Object  -ExpandProperty members
        Write-Host Desgroup start numbers count is $desmembers.count

        $sourcemembers = Get-ADGroup -Identity $sourcegroupname -Properties members | Select-Object -ExpandProperty members
        Write-Host Sourcegroup numbers count is $sourcemembers.count

        foreach($item in $sourcemembers){
            try{
                Write-Host Start migration $item
                Add-ADGroupMember -Identity $desgroupname -Members $item
            }
            catch{
                Write-Host $Error[0]
            }
        }

        $desEndmembers = Get-ADGroup -Identity $desgroupname -Properties members | Select-Object -ExpandProperty members
        Write-Host Desgroup End numbers count is $desEndmembers.count
    }else{
        Write-Host "Please input a valid group name."
    }
}
