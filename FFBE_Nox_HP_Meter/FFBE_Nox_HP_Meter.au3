#Include <Array.au3>

MsgBox(0, "", "Press ESC Key to Exit at anytime.")

HotKeySet("{ESC}", _Terminate)


$sWindowTitle = "Nox App Player"
$sWindowText = "QWidgetClassWindow"
$iColor = 0x000000
$hWin = WinGetHandle($sWindowTitle, $sWindowText)
$aWinPos = WinGetPos($sWindowTitle, $sWindowText)
$iLeft = $aWinPos[2]*.03194
$iRight = $aWinPos[2]*.60702
$iTop = $aWinPos[3]*.5949
$iBottom=$aWinPos[3]*.5949

;MsgBox(0, "", $iLeft & "  "  & $iRight & "  " & $iTop)


SplashTextOn("FFBE HP Meter", "", 150, 50, "", "", 16)

While 1
	Sleep(100)
	$aWinPos = WinGetPos($sWindowTitle, $sWindowText)
	$aPixelSearch = PixelSearch($iLeft+$aWinPos[0], $iTop+$aWinPos[1], $iRight+$aWinPos[0], $iTop+$aWinPos[1], $iColor)
	If @Error Then
		$aPixelSearch = PixelSearch($iRight+$aWinPos[0]-5, $iTop+$aWinPos[1], $iRight+$aWinPos[0]-5, $iTop+$aWinPos[1], 0x92de50, 10)
		If Not @Error Then ControlSetText("FFBE HP Meter", "", "Static1", 100)
		ContinueLoop
	EndIf
	;_ArrayDisplay($aPixelSearch)
	$iVal = ($aPixelSearch[0]-$aWinPos[0]-$iLeft)/($iRight-$iLeft)
	Switch $iVal
		Case $iVal < .1
			$iVal = 0
		Case $iVal > 100
			$iVal = 100
		Case Else
			$iVal = StringLeft($iVal*100, 2)
	EndSwitch
	ControlSetText("FFBE HP Meter", "", "Static1", $iVal)
	;ControlSetText("FFBE HP Meter", "", "Static1", ($aPixelSearch[0]-$aWinPos[0]-$iLeft)/($iRight-$iLeft))
WEnd

Func _Terminate()
	Exit
EndFunc



;_ArrayDisplay($aWinPos)


;MouseMove(918, 680) ;Absolute
;MouseMove(1278, 680) ;Absolute

;MouseMove(20+$aWinPos[0], 680+$aWinPos[1]) ;Relalative
;MouseMove(380+$aWinPos[0], 680+$aWinPos[1]) ;Realative


;x 918 y 680
;x 1278 y 680

;Relative Calculation Width of Nox 626   626*X=20   X= .03194  left
;Relative Calculation Width of Nox 626   626*x=380  X= .60702  right
;Relative Calculation Height of Nox 1143  1143*Y=680  Y=.5949  top/bottom

