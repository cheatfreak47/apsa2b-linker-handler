#NoEnv
#NoTrayIcon
#SingleInstance Force
; Try to read the install location from the 64-bit registry path
RegRead, InstallDir, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\AutoHotkey, InstallDir
; If the above registry path doesn't exist (i.e., on a 32-bit machine), try the 32-bit registry path
if (ErrorLevel) {
    RegRead, InstallDir, HKEY_LOCAL_MACHINE, SOFTWARE\AutoHotkey, InstallDir
}
; If the install location is still not found, show an error message
if (ErrorLevel) {
    MsgBox, 48, Error, AutoHotkey installation location not found in the registry.
    ExitApp
}
RegRead, ArchipelagoPath, HKEY_LOCAL_MACHINE, SOFTWARE\Classes\archipelago\shell\open\command
; Remove the quote at the beginning
ArchipelagoPath := SubStr(ArchipelagoPath, 2)
; Find the position of ".exe"
exePos := InStr(ArchipelagoPath, ".exe")
; Cut off everything after ".exe"
ArchipelagoPath := SubStr(ArchipelagoPath, 1, exePos+3)
; Find the last backslash
lastBackslash := InStr(ArchipelagoPath, "\",, 0)
; Cut off the filename, leaving only the directory path
ArchipelagoPath := SubStr(ArchipelagoPath, 1, lastBackslash-1)
if (!FileExist(build)) {
    ; If it doesn't exist, create it
    FileCreateDir, build
}
; Compile the ahk into an exe
RunWait, "%InstallDir%\Compiler\ahk2exe.exe" /in "%A_WorkingDir%\APSA2BHandler.ahk" /out "%A_WorkingDir%\build\APSA2BHandler.exe" /icon "%ArchipelagoPath%\data\icon.ico"
; Try to read the 7-Zip location from various registry paths
RegRead, SevenZipDir, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\7-Zip, Path
if (ErrorLevel) {
    RegRead, SevenZipDir, HKEY_LOCAL_MACHINE, SOFTWARE\7-Zip, Path
}
if (ErrorLevel) {
	RegRead, SevenZipDir, HKEY_LOCAL_MACHINE, SOFTWARE\Wow6432Node\7-Zip-Zstandard, Path
}
if (ErrorLevel) {
    RegRead, SevenZipDir, HKEY_LOCAL_MACHINE, SOFTWARE\7-Zip-Zstandard, Path
}
; If the 7-Zip location is still not found, show an error message
if (ErrorLevel) {
    MsgBox, 48, Error, 7-Zip installation location not found in the registry.
    ExitApp
}
; Archive the exe for release
Run, "%SevenZipDir%\7z.exe" a "%A_WorkingDir%\build\APSA2BHandler.7z" "%A_WorkingDir%\build\APSA2BHandler.exe"
ExitApp
