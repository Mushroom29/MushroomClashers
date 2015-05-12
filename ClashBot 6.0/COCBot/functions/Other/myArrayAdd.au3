Func myArrayAdd (ByRef $ArrayVar, $Val)
   If ($ArrayVar[0] = -1) Then
	  ; Array not yet used, set it up
	  $ArrayVar[0] = $Val
   Else
	  ; Array already setup so add to it
	  _ArrayAdd ($ArrayVar, $Val)
   EndIf
EndFunc   ;==>myArrayAdd