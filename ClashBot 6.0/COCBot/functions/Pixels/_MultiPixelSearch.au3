;Uses multiple pixels with coordinates of each color in a certain region, works for memory BMP

;$xSkip and $ySkip for numbers of pixels skip
;$offColor[2][COLOR/OFFSETX/OFFSETY] offset relative to firstColor coordination

Func _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, $xSkip, $ySkip, $firstColor, $offColor, $iColorVariation)
	_CaptureRegion($iLeft, $iTop, $iRight, $iBottom)
	; enable this to debug the area that is being parsed
    ;_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\TestPictures\" & "Picture_" & $iLeft & "_" & $iTop & "_" & $iRight & "_" & $iBottom & ".png")
	For $x = 0 To $iRight - $iLeft Step $xSkip
		For $y = 0 To $iBottom - $iTop Step $ySkip
			If _ColorCheck(_GetPixelColor($x, $y), $firstColor, $iColorVariation) Then
				Local $allchecked = True
				For $i = 0 To UBound($offColor) - 1
					If _ColorCheck(_GetPixelColor($x + $offColor[$i][1], $y + $offColor[$i][2]), Hex($offColor[$i][0], 6), $iColorVariation) = False Then
						$allchecked = False
						ExitLoop
					 EndIf
					 ; enable this to debug which pixels are being located in the debug area
					 ;If $allchecked Then
					 ;  SetLog($i & " - " & ($x + $offColor[$i][1]) & " - " & ($y + $offColor[$i][2]) & " - " & Hex($offColor[$i][0], 6) & " - " & _GetPixelColor($x + $offColor[0][1], $y + $offColor[0][2]))
					 ;  SetLog(" Want1 - " & ($x + $offColor[1][1]) & " - " & ($y + $offColor[1][2]) & " - " & Hex($offColor[1][0], 6) & " - " & _GetPixelColor($x + $offColor[1][1], $y + $offColor[1][2]))
					 ;   SetLog(" Want2 - " & ($x + $offColor[2][1]) & " - " & ($y + $offColor[2][2]) & " - " & Hex($offColor[2][0], 6) & " - " & _GetPixelColor($x + $offColor[2][1], $y + $offColor[2][2]))
					 ;EndIf
				Next
				If $allchecked Then
					Local $Pos[2] = [$iLeft + $x, $iTop + $y]
					; enable this to debug the returned position
					; SetLog("Position found: " & $Pos[0] & ", " & $Pos[1])
					Return $Pos
				EndIf
			EndIf
		Next
	Next
	Return 0
EndFunc   ;==>_MultiPixelSearch
