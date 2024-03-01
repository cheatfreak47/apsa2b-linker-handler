#NoEnv
#NoTrayIcon
#SingleInstance Force

if (!A_IsCompiled) {
    MsgBox, 16, Error, This script must be run as a compiled .exe, not as a .ahk script.
    ExitApp
}

if (0 == A_Args.Length()) {
    Gui, Add, Button, w200 h40 gInstall, Install
    Gui, Add, Button, x+10 yp w200 h40 gUninstall, Uninstall
    Gui, Show, , APSA2B URL Handler
    return
}

if (A_Args[1] = "install") {
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, apsa2b,, Archipelago SA2B Protocol
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, apsa2b, URL Protocol
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT, apsa2b\shell\open\command,, "%A_ScriptFullPath%" "`%1"
    MsgBox, 64, SA2B Archipelago Launcher, URL Handler for "apsa2b://" installed successfully.
    ExitApp
} else if (A_Args[1] = "uninstall") {
    ;RegDelete, HKEY_CLASSES_ROOT, apsa2b
    MsgBox, 64, SA2B Archipelago Launcher, URL Handler for "apsa2b://" uninstalled successfully.
    ExitApp
} else {
    URL := A_Args[1]
    StringReplace, URL, URL, apsa2b://, , All
    StringSplit, Components, URL, :@/
    SlotName := Components1
    Password := Components2 = "None" ? "" : Components2
    ServerURL := Components3
    ServerPort := Components4
    ; You can now use the variables SlotName, Password, ServerURL, and ServerPort
	RegRead, SA2BInstall, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 213610, InstallLocation
	if (SA2BInstall = "") {
    MsgBox, 48, Error, Sonic Adventure 2 Battle installation location not found in the registry. Please reinstall Sonic Adventure 2.
    ExitApp
	}
	; Define the path to the config.ini file
	ConfigFile := SA2BInstall . "\mods\SA2B_Archipelago\config.ini"
	; Clear the [AP] section from the INI file
	IniDelete, %ConfigFile%, AP
	; Write the new data to the INI file
	IniWrite, %ServerURL%:%ServerPort%, %ConfigFile%, AP, IP
	IniWrite, %SlotName%, %ConfigFile%, AP, PlayerName
	; If Password is not blank, write it to the INI file
	if (Password != "") {
		IniWrite, %Password%, %ConfigFile%, AP, Password
	}
	; Debug Print Messagebox
	;MsgBox, Slot Name: %SlotName%`nPassword: %Password%`nServer URL: %ServerURL%`nServer Port: %ServerPort%`nInstall: %SA2BInstall%`nConfig: %ConfigFile%
	
	SetWorkingDir, %SA2BInstall%
	if (Password != "") {
		Run, "archipelago://%SlotName%:%Password%@%ServerURL%:%ServerPort%"
	}
	else {
		Run, "archipelago://%SlotName%:None@%ServerURL%:%ServerPort%"
	}
	RunWait, "%SA2BInstall%\sonic2app.exe"
	ExitApp
}

Install:
    Run, *RunAs %A_ScriptFullPath% install
    return

Uninstall:
    Run, *RunAs %A_ScriptFullPath% uninstall
    return
	
GuiClose:
    ExitApp