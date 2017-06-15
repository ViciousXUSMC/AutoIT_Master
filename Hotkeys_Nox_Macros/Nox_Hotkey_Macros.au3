#cs
Nox Hotkey Macros V1.0
Created by Patrick Mosley - Patrick@ViciousComputers.com (ViciousXUSMC)

Change Log:

V1.0
Initial Release
Contains INI File to tune setup for 4 macros
If you want to change hotkey to a different key look up Send Keys for AutoIT to see keys you can use
#ce
;test
$sINIPath = @ScriptDir & "\Nox_Hotkey_Macros.ini"

If Not FileExists($sINIPath) Then MsgBox(0, "", "Can Not Find Nox_Hotkey_Macros.ini - Using Defaults")

$sMacro1Hotkey = IniRead($sINIPath, "Macro1", "Hotkey", "{F1}")
$iMacro1X = IniRead($sINIPath, "Macro1", "X", 275)
$iMacro1Y = IniRead($sINIPath, "Macro1", "Y", 110)

$sMacro2Hotkey = IniRead($sINIPath, "Macro2", "Hotkey", "{F1}")
$iMacro2X = IniRead($sINIPath, "Macro2", "X", 275)
$iMacro2Y = IniRead($sINIPath, "Macro2", "Y", 150)

$sMacro3Hotkey = IniRead($sINIPath, "Macro3", "Hotkey", "{F1}")
$iMacro3X = IniRead($sINIPath, "Macro3", "X", 275)
$iMacro3Y = IniRead($sINIPath, "Macro3", "Y", 190)

$sMacro4Hotkey = IniRead($sINIPath, "Macro4", "Hotkey", "{F1}")
$iMacro4X = IniRead($sINIPath, "Macro4", "X", 275)
$iMacro4Y = IniRead($sINIPath, "Macro4", "Y", 230)

HotKeySet($sMacro1Hotkey, "_Macro1")
HotKeySet($sMacro2Hotkey, "_Macro2")
HotKeySet($sMacro3Hotkey, "_Macro3")
HotKeySet($sMacro4Hotkey, "_Macro4")
HotKeySet("{ESC}", "_Terminate")

While 1
	Sleep(10)
WEnd

Func _Terminate()
	Exit
EndFunc

Func _Macro1()
$aCurrent = MouseGetPos()
$aDestination = WinGetPos("[TITLE:Dialog; CLASS:Qt5QWindow]", "")
MouseClick("left", $aDestination[0]+$iMacro1X, $aDestination[1]+$iMacro1Y, 1, 1)
MouseMove($aCurrent[0], $aCurrent[1], 1)
EndFunc

Func _Macro2()
$aCurrent = MouseGetPos()
$aDestination = WinGetPos("[TITLE:Dialog; CLASS:Qt5QWindow]", "")
MouseClick("left", $aDestination[0]+$iMacro2X, $aDestination[1]+$iMacro2Y, 1, 1)
MouseMove($aCurrent[0], $aCurrent[1], 1)
EndFunc

Func _Macro3()
$aCurrent = MouseGetPos()
$aDestination = WinGetPos("[TITLE:Dialog; CLASS:Qt5QWindow]", "")
MouseClick("left", $aDestination[0]+$iMacro3X, $aDestination[1]+$iMacro3Y, 1, 1)
MouseMove($aCurrent[0], $aCurrent[1], 1)
EndFunc

Func _Macro4()
$aCurrent = MouseGetPos()
$aDestination = WinGetPos("[TITLE:Dialog; CLASS:Qt5QWindow]", "")
MouseClick("left", $aDestination[0]+$iMacro4X, $aDestination[1]+$iMacro4Y, 1, 1)
MouseMove($aCurrent[0], $aCurrent[1], 1)
EndFunc



