;Prints out useful information about your attacks

Func AttackReport() ;Return main screen
   Local Const $MINUTES_PER_HOUR = 60
   Local Const $SECONDS_PER_MINUTE = 60

   Local Const $BARBARIAN_COST_ARRAY = 0
   Local Const $ARCHER_COST_ARRAY = 1
   Local Const $GIANT_COST_ARRAY = 2
   Local Const $GOBLIN_COST_ARRAY = 3
   Local Const $WALLBREAKER_COST_ARRAY = 4
   Local Const $LIGHTNING_SPELL_COST_ARRAY = 5

							   ;Town Hall    1     2     3     4     5     6     7     8     9    10
   Local Const $BARRACKS_COST[6][10] = [[   25,   25,   40,   40,   60,   60,   80,  100,  150,  200], _ ;Barbarian
									    [   50,   50,   80,   80,  120,  120,  160,  200,  300,  400], _ ;Archer
										[  250,  250,  250,  750,  750, 1250, 1750, 2250, 3000, 3500], _ ;Giant
										[   25,   25,   40,   40,   60,   60,   80,  100,  100,  150], _ ;Goblin
										[ 1000, 1000, 1000, 1500, 1500, 2000, 2500, 3000, 3000, 3500], _ ;Wallbreaker
										[15000,15000,16500,18000,20000,20000,20000,22000,22000,24000]]   ;Lightning Spell

   ; Set to "---" by default for the unable to calculate value
   Local $goldPercentRaided = "---"
   Local $elixirPercentRaided = "---"
   Local $darkElixirPercentRaided = "---"
   Local $minutesPerAttack = "---"
   Local $searchesPerAttack = "---"
   Local $errorsPerAttack = "---"
   Local $goldStandardDeviation = "---"
   Local $elixirStandardDeviation = "---"
   Local $darkElixirStandardDeviation = "---"
   Local $averageElixirSpentOnTroops = "---"

   ; time variables
   Local $minutesOfRunningTime = ($min + ($hour * $MINUTES_PER_HOUR) + 1)
   Local $secondsOfRunningTime = ($sec + (($min + ($hour * $MINUTES_PER_HOUR)) * $SECONDS_PER_MINUTE) + 1)
   Local $trainHour = 0
   Local $trainMin = 0
   Local $trainSec = 0
   Local $searchHour = 0
   Local $searchMin = 0
   Local $searchSec = 0
   Local $attackHour = 0
   Local $attackMin = 0
   Local $attackSec = 0

   ; Calculate number of troops deployed in last attack
   Local $deployedBarbarians = $AttackStartingBarbarians - $AttackEndingBarbarians
   Local $deployedArchers = $AttackStartingArchers - $AttackEndingArchers
   Local $deployedGiants = $AttackStartingGiants - $AttackEndingGiants
   Local $deployedGoblins = $AttackStartingGoblins - $AttackEndingGoblins
   Local $deployedWallbreakers = $AttackStartingWallbreakers - $AttackEndingWallbreakers
   Local $deployedLightningSpells = $AttackStartingLightningSpells - $AttackEndingLightningSpells

   ; Calculate the cost of troops deployed in last attack
   Local $lastElixerSpentOnTroops = (($deployedBarbarians * $BARRACKS_COST[$BARBARIAN_COST_ARRAY][$THLevel-1]) + _
									 ($deployedArchers * $BARRACKS_COST[$ARCHER_COST_ARRAY][$THLevel-1]) + _
									 ($deployedGiants * $BARRACKS_COST[$GIANT_COST_ARRAY][$THLevel-1]) + _
									 ($deployedGoblins * $BARRACKS_COST[$GOBLIN_COST_ARRAY][$THLevel-1]) + _
									 ($deployedWallbreakers * $BARRACKS_COST[$WALLBREAKER_COST_ARRAY][$THLevel-1]) + _
									 ($deployedLightningSpells * $BARRACKS_COST[$LIGHTNING_SPELL_COST_ARRAY][$THLevel-1]))
   $TotalElixerSpentOnTroops += $lastElixerSpentOnTroops

   ; Search cost for the last attack
   Local $lastGoldSpentSearching =  ($SearchCountTotalBeforeAttack * $SearchCost)

   ; Gold gained minus search cost per hour
   Local $goldPerHour = Floor((($GoldGained + $LastRaidGold) - GUICtrlRead($lblresultsearchcost)) * $MINUTES_PER_HOUR / $minutesOfRunningTime)
   ; Elixir per hour
   Local $elixirPerHour = Floor((($ElixirGained + $LastRaidElixir) - $TotalElixerSpentOnTroops) * $MINUTES_PER_HOUR / $minutesOfRunningTime)
   ; Dark elixir per hour
   Local $darkElixirPerHour = Floor(($DarkGained + $LastRaidDarkElixir) * $MINUTES_PER_HOUR / $minutesOfRunningTime)

   ; Time between the attack that just finished and the attack before that
   Local $timeSinceLastAttack = (Round((((((($hour - $TimeOfLastAttackHour) * $MINUTES_PER_HOUR) + ($min - $TimeOfLastAttackMin)) * $SECONDS_PER_MINUTE) + ($sec - $TimeOfLastAttackSec)) / $SECONDS_PER_MINUTE) * 100) / 100)
   ; Save the time of the attack that just finished
   $TimeOfLastAttackHour = $hour
   $TimeOfLastAttackMin = $min
   $TimeOfLastAttackSec = $sec

   ; Time to finish find a base to attack and then to attack it
   _TicksToTime(Int($LengthOfTrainTime), $trainHour, $trainMin, $trainSec)
   _TicksToTime(Int($LengthOfSearchTime), $searchHour, $searchMin, $searchSec)
   _TicksToTime(Int($LengthOfAttackTime), $attackHour, $attackMin, $attackSec)

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
	  $errorsPerAttack = (Round(($NumberOfTimesUnableToReadGold / GUICtrlRead($lblresultvillagesattacked)) * 100) / 100)

	  ; Average gold spent on searches rounded to integer
	  $averageGoldSpentSearching = Round(GUICtrlRead($lblresultsearchcost) / GUICtrlRead($lblresultvillagesattacked))

	  ; Average elixir spent on troops rounded to integer
	  $averageElixirSpentOnTroops = Round($TotalElixerSpentOnTroops / GUICtrlRead($lblresultvillagesattacked))
   EndIf

   If (GUICtrlRead($lblresultvillagesattacked) = 0) Then
	  ; do nothing
   Else
	  ; Add newest results to the arrays
	  myArrayAdd($AllGoldGains, $LastRaidGold)
	  myArrayAdd($AllElixirGains, $LastRaidElixir)
	  myArrayAdd($AllDarkElixirGains, $LastRaidDarkElixir)
	  ; Calculate average resources gained per attack
	  Local $goldAverage = Round(_Mean($AllGoldGains),0)
	  Local $elixirAverage = Round(_Mean($AllElixirGains),0)
	  Local $darkElixirAverage = Round(_Mean($AllDarkElixirGains),0)
	  ; if we have enough attacks to calculate standard deviation
	  if (GUICtrlRead($lblresultvillagesattacked) >= 2) Then
		 ; Calculate standard deviation of the resources gained per attack
		 $goldStandardDeviation = _StdDev($AllGoldGains, 0, 1)
		 $elixirStandardDeviation = _StdDev($AllElixirGains, 0, 1)
		 $darkElixirStandardDeviation = _StdDev($AllDarkElixirGains, 0, 1)
	  EndIf
   EndIf

   SetLog("=================Last Attack=================", $COLOR_BLUE)
   SetLog("[Gld+]:" & Tab($LastRaidGold,6) & $LastRaidGold & "  [Gld%]:" & Tab($goldPercentRaided,3) & $goldPercentRaided & "  [GldSpnt]:" & Tab($lastGoldSpentSearching,5) & $lastGoldSpentSearching, $COLOR_GREEN)
   SetLog("[Elx+]:" & Tab($LastRaidElixir,6) & $LastRaidElixir & "  [Elx%]:" & Tab($elixirPercentRaided,3) & $elixirPercentRaided & "  [ElxSpnt]:" & Tab($lastElixerSpentOnTroops,5) & $lastElixerSpentOnTroops, $COLOR_GREEN)
   SetLog("[Dlx+]:" & Tab($LastRaidDarkElixir,6) & $LastRaidDarkElixir & "  [Dlx%]:" & Tab($darkElixirPercentRaided,3) & $darkElixirPercentRaided, $COLOR_GREEN)
   SetLog("[Srchs]:" & Tab($SearchCountTotalBeforeAttack,5) & $SearchCountTotalBeforeAttack & "  [Time]:" & Tab($timeSinceLastAttack,4) & $timeSinceLastAttack, $COLOR_GREEN)
   SetLog("[TrnT]: " & StringFormat("%02i:%02i", $trainMin, $trainSec) & "  [SrchT]: " & StringFormat("%02i:%02i", $searchMin, $searchSec) & "  [AttckT]: " & StringFormat("%02i:%02i", $attackMin, $attackSec), $COLOR_GREEN)
   SetLog("===============Troops Deployed===============", $COLOR_BLUE)
   SetLog("[Barb]:" & Tab($deployedBarbarians,3) & $deployedBarbarians &"  [Arch]:" & Tab($deployedArchers,3) & $deployedArchers & "  [Gbln]:" & Tab($deployedGoblins,3) & $deployedGoblins, $COLOR_GREEN)
   SetLog("[Gint]:" & Tab($deployedGiants,3) & $deployedGiants & "  [Wbkr]:" & Tab($deployedWallbreakers,3) & $deployedWallbreakers & "  [Lght]:" & Tab($deployedLightningSpells,3) & $deployedLightningSpells, $COLOR_GREEN)
   SetLog("================Attack Report================", $COLOR_BLUE)
   SetLog("[Gld/H]:" & Tab($goldPerHour,6) & $goldPerHour & "  [GldAvg]:" & Tab($goldAverage,6) & $goldAverage & "  [GldStdDvn]:" & Tab($goldStandardDeviation,6) & $goldStandardDeviation, $COLOR_GREEN)
   SetLog("[Elx/H]:" & Tab($elixirPerHour,6) & $elixirPerHour & "  [ElxAvg]:" & Tab($elixirAverage,6) & $elixirAverage & "  [ElxStdDvn]:" & Tab($elixirStandardDeviation,6) & $elixirStandardDeviation, $COLOR_GREEN)
   SetLog("[Dlx/H]:" & Tab($darkElixirPerHour,6) & $darkElixirPerHour & "  [DlxAvg]:" & Tab($darkElixirAverage,6) & $darkElixirAverage & "  [DlxStdDvn]:" & Tab($darkElixirStandardDeviation,6) & $darkElixirStandardDeviation, $COLOR_GREEN)
   SetLog("[Attck]:" & Tab($lblresultvillagesattacked,3) & GUICtrlRead($lblresultvillagesattacked) & "  [Gld-/Attck]:" & Tab($averageGoldSpentSearching,5) & $averageGoldSpentSearching & "  [Elx-/Attck]:" & Tab($averageElixirSpentOnTroops,5) & $averageElixirSpentOnTroops, $COLOR_GREEN)
   SetLog("[Time/Attck]:" & Tab($minutesPerAttack,5) & $minutesPerAttack & "  [Srchs/Attck]:" & Tab($searchesPerAttack,4) & $searchesPerAttack & "  [Err/Attck]:" & Tab($errorsPerAttack,3) & $errorsPerAttack, $COLOR_GREEN)
   ; Clear search total now that is has been reported
   $SearchCountTotalBeforeAttack = 0

   ; Start the training timer
   $SearchTrainHandle = TimerInit()
EndFunc   ;==>AttackReport

; Standard Deviation calculation from here http://www.autoitscript.com/forum/topic/86040-standard-deviation-calculator/
; Modified to round to nearest int when $iStdFloat = 0
; #FUNCTION# ;===============================================================================
;
; Name...........: _StdDev
; Description ...: Returns the standard deviation between all numbers stored in an array
; Syntax.........: _StdDev($anArray, $iStdFloat)
; Parameters ....: $anArray - An array containing 2 or more numbers
;                  $iStdFloat - (Optional) The number of decimal places to round for STD
;                  $iType - (Optional) Decides the type of Standard Deviation to use:
;                  |1 - Method One (Standard method using Mean)
;                  |2 - Method Two (Non-Standard method using Squares)
; Return values .: Success - Standard Deviation between multiple numbers
;                  Failure - Returns empty and Sets @Error:
;                  |0 - No error.
;                  |1 - Invalid $anArray (not an array)
;                  |2 - Invalid $anArray (contains less than 2 numbers)
;                  |3 - Invalid $iStdFloat (cannot be negative)
;				   |4 - Invalid $iStdFloat (not an integer)
; Author ........: Ealric
; Modified.......:
; Remarks .......:
; Related .......: _StdDev
; Link ..........;
; Example .......; Yes;
;
;==========================================================================================
Func _StdDev(ByRef $anArray, $iStdFloat = 0, $iType = 1)
	If Not IsArray($anArray) Then Return SetError(1, 0, "") ; Set Error if not an array
	If UBound($anArray) <= 1 Then Return SetError(2, 0, "") ; Set Error if array contains less than 2 numbers
	If $iStdFloat <= -1 Then Return SetError(3, 0, "") ; Set Error if argument is negative
	If Not IsInt($iStdFloat) Then Return SetError(4, 0, "") ; Set Error if argument is not an integer
	Local $n = 0, $nSum = 0
	Local $iMean = _Mean($anArray)
	Local $iCount = _StatsCount($anArray)
	Switch $iType
		Case 1
			For $i = 0 To $iCount - 1
				$n += ($anArray[$i] - $iMean)^2
			Next
;			If ($iStdFloat = 0) Then
;				Local $nStdDev = Sqrt($n / ($iCount-1))
;			Else
				Local $nStdDev = Round(Sqrt($n / ($iCount-1)), $iStdFloat)
;			EndIf
			Return $nStdDev
		Case 2
			For $i = 0 To $iCount - 1
				$n = $n + $anArray[$i]
				$nSum = $nSum + ($anArray[$i] * $anArray[$i])
			Next
;			If ($iStdFloat = 0) Then
;				Local $nStdDev = Sqrt(($nSum - ($n * $n) / $iCount) / ($iCount - 1))
;			Else
				Local $nStdDev = Round(Sqrt(($nSum - ($n * $n) / $iCount) / ($iCount - 1)), $iStdFloat)
;			EndIf
			Return $nStdDev
	EndSwitch
EndFunc   ;==>_StdDev

; #FUNCTION#;===============================================================================
;
; Name...........: _Mean
; Description ...: Returns the mean of a data set, choice of Pythagorean means
; Syntax.........: _Mean(Const ByRef $anArray[, $iStart = 0[, $iEnd = 0[, $iType = 1]]])
; Parameters ....: $anArray - 1D Array containing data set
;                  $iStart - Starting index for calculation inclusion
;                  $iEnd - Last index for calculation inclusion
;                  $iType - One of the following:
;                  |1 - Arithmetic mean (default)
;                  |2 - Geometric mean
;                  |3 - Harmonic mean
; Return values .: Success - Mean of data set
;                  Failure - Returns "" and Sets @Error:
;                  |0 - No error.
;                  |1 - $anArray is not an array or is multidimensional
;                  |2 - Invalid mean type
;                  |3 - Invalid boundaries
; Author ........: Andybiochem
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
;;==========================================================================================
Func _Mean(Const ByRef $anArray, $iStart = 0, $iEnd = 0, $iType = 1)
	If Not IsArray($anArray) Or UBound($anArray, 0) <> 1 Then Return SetError(1, 0, "")
	If Not IsInt($iType) Or $iType < 1 Or $iType > 3 Then Return SetError(2, 0, "")
	Local $iUBound = UBound($anArray) - 1
	If Not IsInt($iStart) Or Not IsInt($iEnd) Then Return SetError(3, 0, "")
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(3, 0, "")
	Local $nSum = 0, $iN = ($iEnd - ($iStart - 1))
	Switch $iType
		Case 1;Arithmetic mean
			For $i = $iStart To $iEnd
				$nSum += $anArray[$i]
			Next
			Return $nSum / $iN
		Case 2;Geometric mean
			For $i = $iStart To $iEnd
				$nSum *= $anArray[$i]
				If $i = $iStart Then $nSum += $anArray[$i]
			Next
			Return $nSum ^ (1 / $iN)
		Case 3;Harmonic mean
			For $i = $iStart To $iEnd
				$nSum += 1 / $anArray[$i]
			Next
			Return $iN / $nSum
	EndSwitch
EndFunc   ;==>_Mean

Func _StatsSum(ByRef $a_Numbers)
	If Not IsArray($a_Numbers) Then SetError(1, 0, "") ;If not an array of value(s) then error and return a blank string
	Local $i_Count = _StatsCount($a_Numbers)
	Local $n_SumX = 0

	For $i = 0 To $i_Count - 1 Step 1
		$n_Sum += $a_Numbers[$i]
	Next

	Return $n_Sum
EndFunc   ;==>_StatsSum

Func _StatsCount(ByRef $a_Numbers)
	Return UBound($a_Numbers)
EndFunc   ;==>_StatsCount
