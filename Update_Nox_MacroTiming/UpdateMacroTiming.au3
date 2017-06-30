#RequireAdmin
#Include <Array.au3>
#Include <File.au3>

Global $iDebug = 0
Global $iDelay = 30
Global $aData
Global $sFile = @ScriptDir & "\input.txt"
Global $sMacroPath = "C:\Users\" & @UserName & "\AppData\Local\Nox\record"
Global $sRegexPattern = "(.*ScRiPtSePaRaToR)(\d*)"

_FileReadToArray($sFile, $aData)

For $i = 1 To $aData[0]
	$aData[$i] = StringRegExpReplace($aData[$i], $sRegexPattern, "${1}" & $iDelay)
	$iDelay = $iDelay + 1
Next

If $iDebug = 1 Then _ArrayDisplay($aData)

_FileWriteFromArray($sFile, $aData, 1)

