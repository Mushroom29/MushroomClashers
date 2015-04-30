;Prints out useful information about your attacks

Func AttackReport() ;Return main screen
   Local Const $MINUTES_PER_HOUR = 60
   Local Const $SECONDS_PER_MINUTE = 60

   Local $minutesOfRunningTime = ($min + ($hour * $MINUTES_PER_HOUR) + 1)
   Local $secondsOfRunningTime = ($sec + (($min + ($hour * $MINUTES_PER_HOUR)) * $SECONDS_PER_MINUTE) + 1)
   ; Gold gained minus search cost per hour
   Local $goldPerHour = Floor((($GoldGained + $LastRaidGold) - GUICtrlRead($lblresultsearchcost)) * $MINUTES_PER_HOUR / $minutesOfRunningTime)
   ; Elixir per hour
   Local $elixirPerHour = Floor(($ElixirGained + $LastRaidElixir) * $MINUTES_PER_HOUR / $minutesOfRunningTime)
   ; Dark elixir per hour
   Local $darkElixirPerHour = Floor(($DarkGained + $LastRaidDarkElixir) * $MINUTES_PER_HOUR / $minutesOfRunningTime)
   ; Percent of gold gained in last raid
   Local $goldPercentRaided = Floor($LastRaidGold / $searchGold * 100)
   If (($goldPercentRaided < 0) Or ($goldPercentRaided > 100)) Then
	 $goldPercentRaided = "ERROR"
   EndIf
   ; Percent of elixir gained in last raid
   Local $elixirPercentRaided = Floor($LastRaidElixir / $searchElixir * 100)
   If (($elixirPercentRaided < 0) Or ($elixirPercentRaided > 100)) Then
	 $elixirPercentRaided = "ERROR"
  EndIf
   ; Percent of dark elixir gained in last raid
   if ($searchDark <> 0) Then
	 Local $darkElixirPercentRaided = Floor($LastRaidDarkElixir / $searchDark * 100)
	 If (($darkElixirPercentRaided < 0) Or ($darkElixirPercentRaided > 100)) Then
		 $darkElixirPercentRaided = "ERROR"
	 EndIf
   Else
	 $darkElixirPercentRaided = "---"
   EndIf

   ; Average time between attacks in minutes to two decimal points
   Local $minutesPerAttack = (Round((($secondsOfRunningTime / GUICtrlRead($lblresultvillagesattacked)) / $SECONDS_PER_MINUTE) * 100) / 100)

; Output all of the resource information into a table
   SetLog("         Gold     Elix     Dark", $COLOR_GREEN)
   SetLog("Last:" & Tab($LastRaidGold,7) & $LastRaidGold & Tab($LastRaidElixir,8) & $LastRaidElixir & Tab($LastRaidDarkElixir,8) & $LastRaidDarkElixir, $COLOR_GREEN)
   SetLog("Perc:" & Tab($goldPercentRaided,7) & $goldPercentRaided & Tab($elixirPercentRaided,8) & $elixirPercentRaided & Tab($darkElixirPercentRaided,8) & $darkElixirPercentRaided, $COLOR_GREEN)
   SetLog("Hour:" & Tab($goldPerHour,7) & $goldPerHour & Tab($elixirPerHour,8) & $elixirPerHour & Tab($darkElixirPerHour,8) & $darkElixirPerHour, $COLOR_GREEN)
   SetLog("Searches: " & $SearchCountTotalBeforeAttack, $COLOR_GREEN)
   SetLog("Time/Atck: " & $minutesPerAttack, $COLOR_GREEN)

   ; Debug messages for temporary verification of averages
   SetLog("Debug $minutesOfRunningTime = " & $minutesOfRunningTime)
   SetLog("Debug $secondsOfRunningTime = " & $secondsOfRunningTime)
   SetLog("Debug $lblresultsearchcost = " & GUICtrlRead($lblresultsearchcost))
   SetLog("Debug $GoldGained = " & $GoldGained)
   SetLog("Debug $LastRaidGold = " & $LastRaidGold)
   SetLog("Debug $ElixirGained = " & $ElixirGained)
   SetLog("Debug $LastRaidElixir = " & $LastRaidElixir)
   SetLog("Debug $DarkGained = " & $LastRaidDarkElixir)
   SetLog("Debug $minutesOfRunningTime = " & $minutesOfRunningTime)
   SetLog("Debug $lblresultvillagesattacked = " & GUICtrlRead($lblresultvillagesattacked))
   SetLog("Debug $minutesPerAttack unrounded = " & (($secondsOfRunningTime * GUICtrlRead($lblresultvillagesattacked)) / $SECONDS_PER_MINUTE))
   SetLog("Debug $minutesPerAttack rounded = " & Round((($secondsOfRunningTime * GUICtrlRead($lblresultvillagesattacked)) / $SECONDS_PER_MINUTE) * 100))


   ; Clear search total now that is has been reported
   $SearchCountTotalBeforeAttack = 0

EndFunc   ;==>AttackReport
