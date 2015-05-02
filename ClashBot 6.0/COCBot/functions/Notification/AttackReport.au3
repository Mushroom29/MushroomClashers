;Prints out useful information about your attacks

Func AttackReport() ;Return main screen
   Local Const $MINUTES_PER_HOUR = 60
   Local Const $SECONDS_PER_MINUTE = 60

   ; Set to "---" by default for the unable to calculate value
   Local $goldPercentRaided = "---"
   Local $elixirPercentRaided = "---"
   Local $darkElixirPercentRaided = "---"
   Local $minutesPerAttack = "---"
   Local $searchesPerAttack = "---"
   Local $errorsPerAttack = "---"

   ; time variables
   Local $minutesOfRunningTime = ($min + ($hour * $MINUTES_PER_HOUR) + 1)
   Local $secondsOfRunningTime = ($sec + (($min + ($hour * $MINUTES_PER_HOUR)) * $SECONDS_PER_MINUTE) + 1)

   ; Gold gained minus search cost per hour
   Local $goldPerHour = Floor((($GoldGained + $LastRaidGold) - GUICtrlRead($lblresultsearchcost)) * $MINUTES_PER_HOUR / $minutesOfRunningTime)
   ; Elixir per hour
   Local $elixirPerHour = Floor(($ElixirGained + $LastRaidElixir) * $MINUTES_PER_HOUR / $minutesOfRunningTime)
   ; Dark elixir per hour
   Local $darkElixirPerHour = Floor(($DarkGained + $LastRaidDarkElixir) * $MINUTES_PER_HOUR / $minutesOfRunningTime)

   ; Time between the attack that just finished and the attack before that
   Local $timeSinceLastAttack = (Round((((((($hour - $TimeOfLastAttackHour) * $MINUTES_PER_HOUR) + ($min - $TimeOfLastAttackMin)) * $SECONDS_PER_MINUTE) + ($sec - $TimeOfLastAttackSec)) / $SECONDS_PER_MINUTE) * 100) / 100)
   ; Save the time of the attack that just finished
   $TimeOfLastAttackHour = $hour
   $TimeOfLastAttackMin = $min
   $TimeOfLastAttackSec = $sec

   ; Percent of gold gained in last raid
   if ($searchGold <> 0) Then
	  $goldPercentRaided = Floor($LastRaidGold / $searchGold * 100)
	  If (($goldPercentRaided < 0) Or ($goldPercentRaided > 100)) Then
		$goldPercentRaided = "ERROR"
	  EndIf
   EndIf

   ; Percent of elixir gained in last raid
   if ($searchElixir <> 0) Then
	  $elixirPercentRaided = Floor($LastRaidElixir / $searchElixir * 100)
	  If (($elixirPercentRaided < 0) Or ($elixirPercentRaided > 100)) Then
		$elixirPercentRaided = "ERROR"
	  EndIf
  EndIf

   ; Percent of dark elixir gained in last raid
   if ($searchDark <> 0) Then
	  $darkElixirPercentRaided = Floor($LastRaidDarkElixir / $searchDark * 100)
	  If (($darkElixirPercentRaided < 0) Or ($darkElixirPercentRaided > 100)) Then
		 $darkElixirPercentRaided = "ERROR"
	  EndIf
   EndIf

   If (GUICtrlRead($lblresultvillagesattacked) <> 0) Then
	  ; Average time between attacks in minutes to two decimal points
	  $minutesPerAttack = (Round((($secondsOfRunningTime / GUICtrlRead($lblresultvillagesattacked)) / $SECONDS_PER_MINUTE) * 100) / 100)

	  ; Average number of searches per attack to two decimal points
	  $SearchCountTotalGlobal += $SearchCountTotalBeforeAttack
	  $searchesPerAttack = (Round(($SearchCountTotalGlobal / GUICtrlRead($lblresultvillagesattacked)) * 100) / 100)

	  ; Average number of errors per attack to two decimal points
	  $errorsPerAttack  = (Round((($NumberOfTimesUnableToReadGold / GUICtrlRead($lblresultvillagesattacked)) / $SECONDS_PER_MINUTE) * 100) / 100)
   EndIf

   SetLog("================Attack Report================", $COLOR_BLUE)
   SetLog("[Gld+]:" & Tab($LastRaidGold,6) & $LastRaidGold & "  [Gld%]:" & Tab($goldPercentRaided,3) & $goldPercentRaided & "  [Gld/H]:" & Tab($goldPerHour,6) & $goldPerHour, $COLOR_GREEN)
   SetLog("[Elx+]:" & Tab($LastRaidElixir,6) & $LastRaidElixir & "  [Elx%]:" & Tab($elixirPercentRaided,3) & $elixirPercentRaided & "  [Elx/H]:" & Tab($elixirPerHour,6) & $elixirPerHour, $COLOR_GREEN)
   SetLog("[Dlx+]:" & Tab($LastRaidDarkElixir,6) & $LastRaidDarkElixir & "  [Dlx%]:" & Tab($darkElixirPercentRaided,3) & $darkElixirPercentRaided & "  [Dlx/H]:" & Tab($darkElixirPerHour,6) & $darkElixirPerHour, $COLOR_GREEN)
   SetLog("[Time]:" & Tab($timeSinceLastAttack,6) & $timeSinceLastAttack & "  [Time/Attck]:" & Tab($minutesPerAttack,5) & $minutesPerAttack, $COLOR_GREEN)
   SetLog("[Srchs]:" & Tab($SearchCountTotalBeforeAttack,5) & $SearchCountTotalBeforeAttack & "  [Srchs/Attck]:" & Tab($searchesPerAttack,4) & $searchesPerAttack, $COLOR_GREEN)
   SetLog("[Err]:" & Tab($NumberOfTimesUnableToReadGold,7) & $NumberOfTimesUnableToReadGold & "  [Err/Atck]:" & Tab($errorsPerAttack,7) & $errorsPerAttack, $COLOR_GREEN)

   ; Clear search total now that is has been reported
   $SearchCountTotalBeforeAttack = 0

EndFunc   ;==>AttackReport
