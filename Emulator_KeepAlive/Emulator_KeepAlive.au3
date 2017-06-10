#cs
Android Emulator Keep Alive v1.1
Created by Patrick Mosley - Patrick@ViciousComputers.com (ViciousXUSMC)

Change Log:

V1.1
Added support for MEmu
Added more INI configuration options
Created Embeded Default INI file for first run
Cleaned up code, removed auto find binaries and require user to open emulator first instead (for cases where install is not in C:)
Plan to find a way to kick off MEmu macros in next version

V1.0
Inital Beta Testing Release
Only working for Nox Emulator at this time
Plan to add Memu support in next version

Special Thanks:
derickso - Telling me about Android ADB as a method to interface instead of me doing it with brute force methods
TheMeph - Created a Powershell Script that emailed when the Emulator would crash, was my modivation to create this
#ce
#RequireAdmin ;Not required for Nox but MEmu requires admin rights to interface with its process.
#Include <array.au3>
#Include <file.au3>
#Include <gmail.au3>
#Include <winapiproc.au3>
#Include <crypt.au3>

HotKeySet("+{ESC}", "_Terminate") ;Shift + Escape exits the program

Global $sINIPath = @ScriptDir & "\Emulator_KeepAlive.ini"

If NOT FileExists($sINIPath) Then
	MsgBox(0, "", "Missing Emulator_KeepAlive.ini - Important configuration options will be set to default and a blank INI file has been created", 10)
	FileInstall("DefaultINI.ini", @ScriptDir & "\Emulator_KeepAlive.ini")
EndIf

Global $iDebug = IniRead($sINIPath, "Debug", "Enable", 0) ;0 Disabled 1 Enable
Global $iHUD = IniRead($sINIPath, "Debug", "HUD", 1)
Global $sEmulator
Global $aBinaryPath
Global $sBinaryPath
Global $sADBPath
Global $iPID
Global $sFFBEPackage
Global $sLogPath = @Scriptdir & "\Emulator_Crash.log"
Global $iNoxMacroX = IniRead($sINIPath, "NoxMacro", "X", 0)
Global $iNoxMacroY = IniRead($sINIPath, "NoxMacro", "Y", 0)
Global $iNoxMacroEnable = IniRead($sINIPath, "NoxMacro", "Enable", 0)
Global $iMailEnable = IniRead($sINIPath, "Email", "Enable", 0)
Global $iMailEncrypted = IniRead($sINIPath, "Email", "Encrypted", 0)
Global $sMailServer = IniRead($sINIPath, "Email", "Server", "smtp.gmail.com")
Global $sMailFromName = IniRead($sINIPath, "Email", "FromName", "Default Name")
Global $sMailFromAddress = IniRead($sINIPath, "Email", "FromADdress", "DefaultAddress@Gmail.com")
Global $sMailToAddress = IniRead($sINIPath, "Email", "ToAddress", "DefaultAddress@Gmail.com")
Global $sMailSubject = IniRead($sINIPath, "Email", "Subject", "Emulator Crash Report")
Global $sMailBody = IniRead($sINIPath, "Email", "Body", "Emulator Just Crashed and was Rebooted")
Global $sMailAccount = IniRead($sINIPath, "Email", "EmailAccount", "DefaultAddress@Gmail.com")
Global $sMailPassword = IniRead($sINIPath, "Email", "EmailPassword", "Password")
Global $iMailPort = IniRead($sINIPath, "Email", "Port", "465")
Global $MailSSL = IniRead($sINIPath, "Email", "SSL", True)

If $iMailEncrypted = 0 And $sMailAccount <> "" And $sMailPassword <> "" Then _EncryptCredentials()
If $iMailEncrypted = 1 Then _DecryptCredentials()
If $iHUD = 1 Then _HUD()

If ProcessExists("Nox.exe") Then
	$sEmulator = "Nox.exe"
	$sADB = "Nox_ADB.exe"
	$iPID = ProcessExists("nox.exe")
ElseIf ProcessExists("Memu.exe") Then
	$sEmulator = "Memu.exe"
	$sADB = "ADB.exe"
	$iPID = ProcessExists("MEmu.exe")
Else
	MsgBox(0, "", "Did not find Nox or Memu running" & @CRLF & "Please open your emulator and try running again")
	Exit
EndIf

MsgBox(0, "", "Script will proceed using " & $sEmulator & " as target emulator", 10)
$sBinaryPath = _WinAPI_GetProcessFileName($iPID)
If $sEmulator = "Nox.exe" Then $sADBPath = StringReplace($sBinaryPath, "nox.exe", "")
If $sEmulator = "Memu.exe" Then $sADBPath = StringReplace($sBinaryPath, "memu.exe", "")
If $iDebug = 1 Then MsgBox(0, "", "ADB Path = " & $sADBPath)

AdlibRegister("_CheckEmulator", 1000 * 10)

While 1
	Sleep(10)
WEnd

Func _CheckEmulator()
	If ProcessExists($sEmulator) Then
		_RelaunchGame()
	Else
		ShellExecute($sBinaryPath)
		_FileWriteLog($sLogPath, "Detected Emulator Crash - Relaunching")
		If $iMailEnable = 1 Then _SendEmail()
		_RelaunchGame()
	EndIf
EndFunc

Func _SendEmail()
	_INetSmtpMailCom($sMailServer, $sMailFromName, $sMailFromAddress, $sMailToAddress, $sMailSubject, $sMailBody, "", "", "", "", $sMailAccount, $sMailPassword, $iMailPort, $MailSSL)
	_FileWriteLog($sLogPath, "Sending E-Mail Message Notice of Emulator Crash")
EndFunc

Func _RelaunchGame()
	Do
		Sleep(100)
		$iPID = Run(@ComSpec & ' /c ' & $sADB & ' shell ps', $sADBPath, @SW_HIDE, $STDOUT_CHILD)
		ProcessWaitClose($iPID)
		$sOutput = StdOutRead($iPID)
	Until NOT StringinStr($sOutput, "device not found")
	Sleep(10000)
	If $sFFBEPackage = "" Then
		$iPID = Run(@ComSpec & ' /c ' & $sADB & ' shell pm list packages -f', $sADBPath, @SW_HIDE, $STDOUT_CHILD)
		ProcessWaitClose($iPID)
		$sOutput = StdOutRead($iPID)
		If StringInStr($sOutput, "daemon not running") OR StringInStr($sOutput, "device not found") Then Return
		If $iDebug = 1 Then MsgBox(0, "Output String", $sOutput)
		$aFFBEPackage = StringRegExp($sOutput, "(?i)apk=(com.*FFBE.*)", $STR_REGEXPARRAYMATCH)
		If $iDebug = 1 Then _ArrayDisplay($aFFBEPackage)
		$sFFBEPackage = $aFFBEPackage[0]
		If $iDebug = 1 Then MsgBox(0, "", "Got FFBE Package Data")
	EndIf
	_CheckRunning($sFFBEPackage)
EndFunc

Func _CheckRunning($sFFBEPackage)
	$iPID = Run(@ComSpec & ' /c ' & $sADB & ' shell dumpsys activity activities', $sADBPath, @SW_HIDE, $STDOUT_CHILD)
	ProcessWaitClose($iPID)
	$sOutput = StdOutRead($iPID)
	If StringInStr($sOutput, "daemon not running") OR StringInStr($sOutput, "devices not found") Then Return
	If $iDebug = 1 Then MsgBox(0, "Output String", $sOutput)
	$aRecentTask = StringRegExp($sOutput, "(?i)Recent tasks:\s*.*A=([^\s]*)", $STR_REGEXPARRAYMATCH)
	If $iDebug = 1 Then _ArrayDisplay($aRecentTask)
	If NOT IsArray($aRecentTask) Then Return
	If $aRecentTask[0] <> $sFFBEPackage Then
		If $iDebug = 1 Then MsgBox(0, "", "Not Running FFBE")
		RunWait(@ComSpec & ' /c ' & $sADB & ' shell am force-stop ' & $sFFBEPackage, $sADBPath, @SW_HIDE)
		_FileWriteLog($sLogPath, "FFBE Not Detected as Active or has Crashed, Force Killing all FFBE Processes")
		Run(@ComSpec & ' /c ' & $sADB & ' shell monkey -p ' & $sFFBEPackage & ' -c android.intent.category.LAUNCHER 1', $sADBPath, @SW_HIDE)
		_FileWriteLog($sLogPath, "Relaunching FFBE Application")
		If $iNoxMacroEnable = 1 AND $sEmulator = "Nox.exe" Then _CheckMacro()
		Return False
	Else
		If $iDebug = 1 Then MsgBox("", "", "Running FFBE")
		Return True
	EndIf
EndFunc

Func _CheckMacro()
	WinActivate("Nox App Player", "")
	Send("^9")
	Sleep(1500)
	$aPos = WinGetPos("[TITLE:Dialog; CLASS:Qt5QWindow]", "")
	If @Error Then Return
	$iColor = PixelGetColor($aPos[0]+$iNoxMacroX, $aPos[1]+$iNoxMacroY)
	If @Error Then Return
	If $iColor <> 578297 Then
		MouseClick("left", $aPos[0]+$iNoxMacroX, $aPos[1]+$iNoxMacroY, 1, 1)
		_FileWriteLog($sLogPath, "Macro detected as not running - Starting Macro")
	EndIf
EndFunc

Func _HUD()
	SplashTextOn("", "Emulator Keep-Alive Running - Shift+Esc to Exit", 250, 40, @DesktopWidth/2, 0, $DLG_NOTITLE+$DLG_NOTONTOP, "", 8)
EndFunc

Func _Terminate()
	Exit
EndFunc

Func _EncryptCredentials()
	IniWrite($sINIPath, "Email", "FromAddress", _Crypt_EncryptData($sMailFromAddress, @UserName, 0x00006610))
	IniWrite($sINIPath, "Email", "ToAddress", _Crypt_EncryptData($sMailToAddress, @UserName, 0x00006610))
	IniWrite($sINIPath, "Email", "EmailAccount", _Crypt_EncryptData($sMailAccount, @UserName, 0x00006610))
	IniWrite($sINIPath, "Email", "EmailPassword", _Crypt_EncryptData($sMailPassword, @UserName, 0x00006610))
	IniWrite($sINIPath, "Email", "Encrypted", 1)
EndFunc

Func _DecryptCredentials()
	$sMailFromAddress=BinaryToString(_Crypt_DecryptData($sMailFromAddress, @UserName, 0x00006610))
	$sMailToAddress=BinaryToString(_Crypt_DecryptData($sMailToAddress, @UserName, 0x00006610))
	$sMailAccount=BinaryToString(_Crypt_DecryptData($sMailAccount, @UserName, 0x00006610))
	$sMailPassword=BinaryToString(_Crypt_DecryptData($sMailPassword, @UserName, 0x00006610))
EndFunc
