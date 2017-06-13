#Include <Array.au3>
#RequireAdmin

MsgBox(0, "", "Press ESC Key to Exit at anytime.")

HotKeySet("{ESC}", _Terminate)

$sINI = @ScriptDir & "\FFBE_Nox_HP_Meter.ini"
$sWindowTitle = IniRead($sINI, "Nox_Settings", "WindowName", "Nox App Player")
$sWindowText = ""
$iColor = 0x000000
$hWin = WinGetHandle($sWindowTitle, $sWindowText)
If @Error Then
	MsgBox(0, "", "Could not Find Nox Window - Exiting")
	Exit
EndIf
WinActivate($sWindowTitle, $sWindowText)
$aWinPos = WinGetPos($sWindowTitle, $sWindowText)
If @Error Then
	MsgBox(0, "", "Could not Find Nox Window - Exiting")
	Exit
EndIf
$iLeft = $aWinPos[2]*.03194
$iRight = $aWinPos[2]*.60702
$iTop = $aWinPos[3]*.5949
$iBottom = $aWinPos[3]*.5949
$iBattleCheckX = $aWinPos[2]*.84185
$iBattleCheckY = $aWinPos[3]*.96237


;_ArrayDisplay($aWinPos) ;See Current Window Coordinates and Specs
;MouseMove($iBattleCheckX+$aWinPos[0], $iBattleCheckY+$aWinPos[1]) ;Check Position of Battle Check
;MouseMove($iLeft+$aWinPos[0], $iTop+$aWinPos[1]) ;Check Position of Left HP
;MouseMove($iRight+$aWinPos[0], $iTop+$aWinPos[1]) ;Check Position of Right HP


SplashTextOn("FFBE HP Meter", "", 100, 40, $aWinPos[0], $aWinPos[1], 16, "", 14, 700)

While 1
	Sleep(100)
	$aBattleCheck = PixelSearch($iBattleCheckX+$aWinPos[0], $iBattleCheckY+$aWinPos[1], $iBattleCheckX+$aWinPos[0], $iBattleCheckY+$aWinPos[1], 0xfffcfd, 10)
	If @Error Then
		ControlSetText("FFBE HP Meter", "", "Static1", "0")
	Else
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
			$iVal = 1
		Case $iVal > 100
			$iVal = 100
		Case Else
			$iVal = StringLeft($iVal*100, 2)
	EndSwitch
	ControlSetText("FFBE HP Meter", "", "Static1", $iVal)
	;ControlSetText("FFBE HP Meter", "", "Static1", ($aPixelSearch[0]-$aWinPos[0]-$iLeft)/($iRight-$iLeft))
	EndIf
WEnd

Func _Terminate()
	Exit
EndFunc



;_ArrayDisplay($aWinPos)
;aWinPos 898 for X   0 for Y

;MouseMove(918, 680) ;Absolute
;MouseMove(1278, 680) ;Absolute

;MouseMove(20+$aWinPos[0], 680+$aWinPos[1]) ;Relalative
;MouseMove(380+$aWinPos[0], 680+$aWinPos[1]) ;Realative


;x 918 y 680
;x 1278 y 680

;Relative Calculation Width of Nox 626   626*X=20   X= .03194  left
;Relative Calculation Width of Nox 626   626*x=380  X= .60702  right
;Relative Calculation Height of Nox 1143  1143*Y=680  Y=.5949  top/bottom


;3345 1100 for In Battle Menu Check  Color 0xfffcfd

;x 1425 y 1100 absolute for Menu Check
;x 527+$aWinPos[0] for X
;y 1100+$aWinPos[1] for Y

;Relative Calc for Width of Nox 626  626*X=527  X = .84185
;Relative Calc for Height of Nox 1143   1143*Y=1100 Y = .96237
;MouseMove($iBattleCheckX+$aWinPos[0], $iBattleCheckY+$aWinPos[1])

