$ClashBotLogFiles = "C:\Users\Kevin Johnson\Desktop\KevinKlashSharedFolder\ClashBot 6.0\ClashBot 6.0\logs\*.log"

$FullLogFile = "C:\Users\Kevin Johnson\Dropbox\FullLog.txt"
$ResourceLogFile = "C:\Users\Kevin Johnson\Dropbox\ResourceLog.txt"
$MatchingLogFile = "C:\Users\Kevin Johnson\Dropbox\MatchingLog.txt"
$WallsLogFile = "C:\Users\Kevin Johnson\Dropbox\WallsLog.txt"
$AttackReportLogFile = "C:\Users\Kevin Johnson\Dropbox\AttackReportLog.txt"

$CharToOmit = 11

#$limit = (Get-Date).AddDays(-1)
while($true)
{
    # Delete files older than the $limit.
    #Get-ChildItem -Path $ClashBotLogFiles -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force -WhatIf
    #Remove-Item $ClashBotLogFiles\*.txt | where {!$_.PSIsContainer -and $_.CreationTime -lt $limit}

    $FullData = Get-Content $ClashBotLogFiles | select -Last 500
    Clear-Content $FullLogFile
    if($FullData)
    {
        # Reverse the log file so newest is on top
        [array]::Reverse($FullData)
        # Add to the log file and omit the characters from the date stamp
        Add-Content $FullLogFile $FullData.substring($CharToOmit)
    }

    $ResourceData = Get-Content $ClashBotLogFiles | where { $_ -match "Resources: " } | select -Last 100
    Clear-Content $ResourceLogFile
    if($ResourceData)
    {
        # Reverse the log file so newest is on top
        [array]::Reverse($ResourceData)
        # Add to the log file and omit the characters from the date stamp
        Add-Content $ResourceLogFile $ResourceData.substring($CharToOmit)
    }

    $MatchingData = Get-Content $ClashBotLogFiles | where { $_ -match "\) \[G\]" -or $_ -match "Searching Complete" -or $_ -match "Last Raid" } | select -Last 200
    Clear-Content $MatchingLogFile
    if($MatchingData)
    {
        # Reverse the log file so newest is on top
        [array]::Reverse($MatchingData)
        # Add to the log file and omit the characters from the date stamp
        Add-Content $MatchingLogFile $MatchingData.substring($CharToOmit)
    }

    $WallsData = Get-Content $ClashBotLogFiles | where { $_ -match "Number of Walls Upgraded: " } | select -Last 100
    Clear-Content $WallsLogFile
    if($WallsData)
    {
        # Reverse the log file so newest is on top
        [array]::Reverse($WallsData)
        # Add to the log file and omit the characters from the date stamp
        Add-Content $WallsLogFile $WallsData.substring($CharToOmit)
    }

    $AttackReportData = Get-Content $ClashBotLogFiles | where { $_ -match "=Attack Report=" -or $_ -match "\[Gld\+\]:" -or $_ -match "\[Elx\+\]:" -or $_ -match "\[Dlx\+\]:" -or $_ -match "\[Time\+\]:" -or $_ -match "\[Srchs\]:" -or $_ -match "\[Err\]:"} | select -Last 100
    Clear-Content $AttackReportLogFile
    if($AttackReportData)
    {
        # Reverse the log file so newest is on top
        [array]::Reverse($AttackReportData)
        # Add to the log file and omit the characters from the date stamp
        Add-Content $AttackReportLogFile $AttackReportData.substring($CharToOmit)
    }

    #wait 60 seconds before updating logs again
    Start-Sleep -s 60
}