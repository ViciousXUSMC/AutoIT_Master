#RequireAdmin
#Include <Array.au3>
#Include <File.au3>

Global $iDebug = 0
If $CmdLine[0] > 0 Then $iDebug = 1
Global $iDelay = 30
Global $aData
Global $sFile
Global $aFile
Global $sMacroPath = "C:\Users\" & @UserName & "\AppData\Local\Nox\record"
Global $sRegexPattern = "(.*ScRiPtSePaRaToR)(\d*)"

$aFile = _FileListToArray($sMacroPath, "*", $FLTA_FILES, True)
If @error Then
	MsgBox(0, "", "Could Not Find Any Macro Files in " & $sMacroPath & @CRLF & @CRLF & "Exiting...")
	Exit
EndIf

If $iDebug = 1 Then _ArrayDisplay($aFile)

_ArrayColInsert($aFile, 1)

If $iDebug = 1 Then _ArrayDisplay($aFile)

For $i = 1 To $aFile[0][0]
	$aFile[$i][1] = FileGetTime($aFile[$i][0], 0, 1)
Next

If $iDebug = 1 Then _ArrayDisplay($aFile)

_ArraySort($aFile, 0, 1, 0, 1)

If $iDebug = 1 Then _ArrayDisplay($aFile)

$sFile = $aFile[$aFile[0][0]][0]
If StringInStr($sFile, "records") Then $sFile = $aFile[($aFile[0][0])-1][0]

If $iDebug = 1 Then MsgBox(0, "", $sFile)

_FileReadToArray($sFile, $aData)

If $iDebug = 1 Then _ArrayDisplay($aData)

For $i = 1 To $aData[0]
	$aData[$i] = StringRegExpReplace($aData[$i], $sRegexPattern, "${1}" & $iDelay)
	$iDelay = $iDelay + 1
Next

If $iDebug = 1 Then _ArrayDisplay($aData)

$iProceed = MsgBox(4, "", "About to update information in file" & @CRLF & @CRLF & $sFile & @CRLF & @CRLF & "OK To Proceed?")
If $iProceed = 6 Then _FileWriteFromArray($sFile, $aData, 1)

