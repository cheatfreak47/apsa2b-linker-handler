; APSA2B URL Handler 1.0 by CheatFreak
; Specify some script settings to ensure it is running as it should.
#NoEnv
#NoTrayIcon
#SingleInstance Force

; Checks if the program is running *as* an AHK script or if it has been compiled and handles it if it isn't compiled. The program only works if it is compiled, because you cannot associate a URL with an ahk file.
if (!A_IsCompiled) {
    MsgBox, 16, Error, This script must be run as a compiled .exe, not as a .ahk script.
    ExitApp
}

; Creates the URL Handler Install/Uninstall GUI and jumps to the actions it is supposed to take in that case
if (0 == A_Args.Length()) {
    Gui, Add, Button, w200 h40 gInstall, Install
    Gui, Add, Button, x+10 yp w200 h40 gUninstall, Uninstall
    Gui, Show, , APSA2B URL Handler
    return
}

; Check the argument it is run with and perform actions based on that.
if (A_Args[1] = "install") {
	; Install the Registry Keys necessary to have this compiled script act as the associated program for running apsa2b:// urls.
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, apsa2b,, Archipelago SA2B Protocol
	RegWrite, REG_SZ, HKEY_CLASSES_ROOT, apsa2b, URL Protocol
    RegWrite, REG_SZ, HKEY_CLASSES_ROOT, apsa2b\shell\open\command,, "%A_ScriptFullPath%" "`%1"
	; Print a text box indicating installation success
    MsgBox, 64, APSA2B URL Handler, URL Handler for "apsa2b://" installed successfully.
    ExitApp
} else if (A_Args[1] = "uninstall") {
    ; Uninstall the Registry Class for the URL entirely. This deletes all sub-keys we made as well and effectively unregistering the URL Handler.
	RegDelete, HKEY_CLASSES_ROOT, apsa2b
    MsgBox, 64, APSA2B URL Handler, URL Handler for "apsa2b://" uninstalled successfully.
    ExitApp
} else {
    ; if neither install or uninstall was specified, but there is an argument, we assume it is being launched as the URL Handler and process the URL for it's data, which are being stored in variables.
	URL := A_Args[1]
	if (InStr(URL, "apsa2b://") = 0) {
    MsgBox, 48, Error, Invalid argument. This program only accepts Install, Uninstall, or a valid apsa2b:// url as an argument.
    ExitApp
	}
    StringReplace, URL, URL, apsa2b://, , All
    StringSplit, Components, URL, :@/
    SlotName := Components1
	; if the password is "None" this literally means no password and we should purposely blank it.
    Password := Components2 = "None" ? "" : Components2
    ServerURL := Components3
    ServerPort := Components4
	if (SlotName = "" or ServerURL = "" or ServerPort = "") {
    MsgBox, 48, Error, Invalid apsa2b URL.
    ExitApp
	}
    ; Read the install location for SA2B from the registry
	RegRead, SA2BInstall, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 213610, InstallLocation
	; If the install location is blank, unfortunately the only real solution is to throw an error and instruct the user to uninstall the game from Steam and Reinstall the game from Steam. Sometimes the Regkey is cleared when the game is moved from one drive to another and there's no way to reconcile this other than a clean reinstall.
	if (SA2BInstall = "") {
    MsgBox, 48, Error, Sonic Adventure 2 Battle installation location not found in the registry. Please uninstall and reinstall Sonic Adventure 2 via Steam.
    ExitApp
	}
	; This next section updates the SA2B_Archipelago mod's config.ini with the necessary data to launch the game with the server, slot, and password specified in the URL.
	; Define the path to the config.ini file
	ConfigFile := SA2BInstall . "\mods\SA2B_Archipelago\config.ini"
	; Clear the [AP] section from the INI file
	IniDelete, %ConfigFile%, AP
	; Write the new data to the INI file using our nicely defined variables
	IniWrite, %ServerURL%:%ServerPort%, %ConfigFile%, AP, IP
	IniWrite, %SlotName%, %ConfigFile%, AP, PlayerName
	; If Password is not blank, write it to the INI file, if it is, simply skip this step
	if (Password != "") {
		IniWrite, %Password%, %ConfigFile%, AP, Password
	}
	; This line is a debug line I've commented out. It just prints the variables to a text box. It was used to validate that we can read the data correctly from all the required locations.
	;MsgBox, Slot Name: %SlotName%`nPassword: %Password%`nServer URL: %ServerURL%`nServer Port: %ServerPort%`nInstall: %SA2BInstall%`nConfig: %ConfigFile%
	; Next we set our working directory to the install folder for SA2B because if we don't SA2B will crash.
	SetWorkingDir, %SA2BInstall%
	; We check if there is a password and launch the text client accordingly, again using our variables.
	if (Password != "") {
		Run, "archipelago://%SlotName%:%Password%@%ServerURL%:%ServerPort%"
	}
	else {
		Run, "archipelago://%SlotName%:None@%ServerURL%:%ServerPort%"
	}
	; We run the game and then exit the script.
	Run, "%SA2BInstall%\sonic2app.exe"
	ExitApp
}

; If Install is clicked we rerun with the install argument
Install:
    Run, *RunAs %A_ScriptFullPath% install
    return
; If Uninstall is clicked we rerun with the uninstall argument
Uninstall:
    Run, *RunAs %A_ScriptFullPath% uninstall
    return
; If the GUI is closed whilest it is open we terminate the script
GuiClose:
    ExitApp
