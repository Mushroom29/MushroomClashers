#Copy my files from my work fold to the GitHub folder
$to="C:\Users\Kevin Johnson\Documents\GitHub\MushroomClashers\ClashBot 6.0"
$from="C:\Users\Kevin Johnson\Desktop\KevinKlashSharedFolder\ClashBot 6.0\ClashBot 6.0"
$exclude="*.jpg","*.log","*.ini"

Get-ChildItem -Path $from -Recurse -Exclude $exclude | 
          where { $excludeMatch -eq $null -or $_.FullName.Replace($from, "") -notmatch $excludeMatch } |
          Copy-Item -Destination {
            if ($_.PSIsContainer) {
              Join-Path $to $_.Parent.FullName.Substring($from.length)
            } else {
              Join-Path $to $_.FullName.Substring($from.length)
            }
           } -Force -Exclude $exclude