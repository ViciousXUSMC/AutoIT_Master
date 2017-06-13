#Include <Array.au3>
#RequireAdmin

MsgBox(0, "", "Press ESC Key to Exit at anytime.")

HotKeySet("{ESC}", _Terminate)

$sINI = @ScriptDir & "\FFBE_Nox_HP_Meter.ini"
$iDebug = IniRead($sINI, "Debug", "Enable", 0)
$iVerbos = IniRead($sINI, "Debug", "Verbose", 0)
$sWindowTitle = IniRead($sINI, "Nox_Settings", "WindowName", "Nox App Player")
$sWindowText = IniRead($sINI, "Nox_Settings", "WindowText", "")
$sOutOfBattleText = IniRead($sINI, "Extra", "OutOfBattleText", "--")
$iHPColor = 0x000000 ;Black
$iHPColor2 = 0x92de50 ;Neon Green
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

$iLeft = IniRead($sINI, "HP_Bar_Detection", "LeftX", "Default")
If $iLeft = "Default" Then $iLeft = $aWinPos[2]*.03194

$iRight = IniRead($sINI, "HP_Bar_Detection", "RightX", "Default")
If $iRight = "Default" Then $iRight = $aWinPos[2]*.60702

$iTop = IniRead($sINI, "HP_Bar_Detection", "TopY", "Default")
If $iTop = "Default" Then $iTop = $aWinPos[3]*.5949

$iBottom = IniRead($sINI, "HP_Bar_Detection", "BottomY", "Default")
If $iBottom = "Default" Then $iBottom = $aWinPos[3]*.5949

$iBattleCheckX = IniRead($sINI, "In_Battle_Detection", "Check1X", "Default")
If $iBattleCheckX = "Default" Then $iBattleCheckX = $aWinPos[2]*.45367 ;New Value on Repeat Icon

$iBattleCheckY = IniRead($sINI, "In_Battle_Detection", "Check1Y", "Default")
If $iBattleCheckY = "Default" Then $iBattleCheckY = $aWinPos[3]*.96412 ;New Value on Repeat Icon

$iBattleCheckX2 = IniRead($sINI, "In_Battle_Detection", "Check2X", "Default")
If $iBattleCheckX2 = "Default" Then $iBattleCheckX2 = $aWinPos[2]*.84185 ;Old Values on Menu Icon

$iBattleCheckY2 = IniRead($sINI, "In_Battle_Detection", "Check2Y", "Default")
If $iBattleCheckY2 = "Default" Then $iBattleCheckY2 = $aWinPos[3]*.96237 ;Old Values on Menu Icon

$iColor1 = IniRead($sINI, "In_Battle_Detection", "Color1", "Default")
If $iColor1 = "Default" Then $iColor1 = 0xfffcfd ;Almost White

$iColor2 = IniRead($sINI, "In_Battle_Detection", "Color2", "Default")
If $iColor2 = "Default" Then $iColor2 = 0xfffcfd ;Almost White

If $iDebug = 1 Then HotKeySet("{F1}", "_LeftHPCheck")
If $iDebug = 1 Then HotKeySet("{F2}", "_RightHPCheck")
If $iDebug = 1 Then HotKeySet("{F3}", "_BattleCheck")
If $iDebug = 1 Then HotKeySet("{F4}", "_BattleCheck2")
If $iVerbos = 1 Then _ArrayDisplay($aWinPos)

SplashTextOn("FFBE HP Meter", "", 100, 40, $aWinPos[0], $aWinPos[1], 16, "", 14, 700)

While 1
	Sleep(100)
	$aBattleCheck = PixelSearch($iBattleCheckX+$aWinPos[0], $iBattleCheckY+$aWinPos[1], $iBattleCheckX+$aWinPos[0], $iBattleCheckY+$aWinPos[1], $iColor1, 10)
	If @Error Then PixelSearch($iBattleCheckX2+$aWinPos[0], $iBattleCheckY2+$aWinPos[1], $iBattleCheckX2+$aWinPos[0], $iBattleCheckY2+$aWinPos[1], $iColor2, 10)
	If @Error Then
		ControlSetText("FFBE HP Meter", "", "Static1", $sOutOfBattleText)
	Else
	$aWinPos = WinGetPos($sWindowTitle, $sWindowText)
	$aPixelSearch = PixelSearch($iLeft+$aWinPos[0], $iTop+$aWinPos[1], $iRight+$aWinPos[0], $iBottom+$aWinPos[1], $iHPColor)
	If @Error Then
		$aPixelSearch = PixelSearch($iRight+$aWinPos[0]-5, $iTop+$aWinPos[1], $iRight+$aWinPos[0]-5, $iBottom+$aWinPos[1], $iHPColor2, 10) ;Searches for Green 5 pixels to the left to see if HP bar is there
		If Not @Error Then ControlSetText("FFBE HP Meter", "", "Static1", 100)
		ContinueLoop
	EndIf
	;_ArrayDisplay($aPixelSearch)
	$iVal = ($aPixelSearch[0]-$aWinPos[0]-$iLeft)/($iRight-$iLeft)
	Switch $iVal
		Case $iVal < .01
			$iVal = 0
		Case $iVal > 100
			$iVal = 100
		Case Else
			$aVal = StringRegExp($iVal*100, "(.*)\.", 1)
			$iVal = $aVal[0]
	EndSwitch
	ControlSetText("FFBE HP Meter", "", "Static1", $iVal)
	EndIf
WEnd

Func _Terminate()
	Exit
EndFunc

Func _LeftHPCheck()
	MouseMove($iLeft+$aWinPos[0], $iTop+$aWinPos[1])
EndFunc

Func _RightHPCheck()
	MouseMove($iRight+$aWinPos[0], $iTop+$aWinPos[1])
EndFunc

Func _BattleCheck()
	MouseMOve($iBattleCheckX+$aWinPos[0], $iBattleCheckY+$aWinPos[1])
EndFunc

Func _BattleCheck2()
	MouseMOve($iBattleCheckX2+$aWinPos[0], $iBattleCheckY2+$aWinPos[1])
EndFunc