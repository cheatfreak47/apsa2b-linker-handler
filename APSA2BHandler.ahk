; APSA2B URL Handler 1.0.4 by CheatFreak
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
	; if the password is "None" this literally means no password and we should purposely blank it. Side note, this is really stupid and they should have done this differently.
    Password := Components2 = "None" ? "" : Components2
    ServerURL := Components3
    ServerPort := Components4
	if (SlotName = "" or ServerURL = "" or ServerPort = "" or ServerPort = "0") {
    MsgBox, 48, Error, Invalid apsa2b URL.`nTry refreshing the page or updating the APSA2B Linker userscript.
    ExitApp
	}
    ; Read the install location for SA2B from the registry
	RegRead, SA2BInstall, HKEY_LOCAL_MACHINE, SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 213610, InstallLocation
	; If a working location wasn't found from Steam's uninstall record, check another possible key that may contain a working path.
	if (SA2BInstall = "") or (!FileExist(SA2BInstall)) {
	RegRead, SA2BInstall, HKEY_LOCAL_MACHINE, SOFTWARE\WOW6432Node\sega\sonicad2, install_path
	}
	; If the install location is still blank, unfortunately the only real solution is to throw an error and instruct the user to uninstall the game from Steam and Reinstall the game from Steam. Sometimes the Regkey is cleared or not updated properly to resolve to the actual location when the game is moved from one drive to another and there's no way to reconcile this other than a clean reinstall.
	if (SA2BInstall = "") or (!FileExist(SA2BInstall)) {
    MsgBox, 48, Error, A working Sonic Adventure 2 Battle installation location was not found in the registry.`n`nSometimes this happens if you've moved the install from one drive to another, or if the game was copied from another computer.`n`nTo fix this, try running the game again from Steam, or backup your mods folder and uninstall and reinstall the game again via Steam. Then set up a fresh copy of the Mod Manager, and restore your mods folder backup.`n`nIf none of this resolves it, please report it on the Github Issue tracker.
    ExitApp
	}
	; This next section updates the SA2B_Archipelago mod's config.ini with the necessary data to launch the game with the server, slot, and password specified in the URL.
	; Define the path to the config.ini file
	APConfigFile := SA2BInstall . "\mods\SA2B_Archipelago\config.ini"
	; Check if the mod config file exists
	if !FileExist(APConfigFile)
	{
		MsgBox, 48, Error, Your SA2B_Archipelago Mod or SA2 Mod Loader may not be installed correctly. Please ensure you set up the SA2 Mod Loader and SA2B_Archipelago Mod correctly.
		ExitApp
	}
	; Clear the [AP] section from the INI file
	IniDelete, %APConfigFile%, AP
	; Write the new data to the INI file using our nicely defined variables
	IniWrite, %ServerURL%:%ServerPort%, %APConfigFile%, AP, IP
	IniWrite, %SlotName%, %APConfigFile%, AP, PlayerName
	; If Password is not blank, write it to the INI file, if it is, simply skip this step
	if (Password != "") {
		IniWrite, %Password%, %APConfigFile%, AP, Password
	}
	; This line is a debug line I've commented out. It just prints the variables to a text box. It was used to validate that we can read the data correctly from all the required locations.
	;MsgBox, Slot Name: %SlotName%`nPassword: %Password%`nServer URL: %ServerURL%`nServer Port: %ServerPort%`nInstall: %SA2BInstall%`nConfig: %APConfigFile%
	; Next we set our working directory to the install folder for SA2B because if we don't SA2B will crash.
	SetWorkingDir, %SA2BInstall%
	; This part here took me a while to actually get working for some reason. I wouldn't normally define extra variables like this but it just wouldn't work otherwise for whatever reason.
	; Define the path to the SA2ModLoader Config
	;MLConfigFile := SA2BInstall . "\mods\SA2ModLoader.ini"
	; Check if the mod loader config file exists before we run anything
	;if (FileExist(MLConfigFile)) {
		; read the file into a variable
	;	FileRead, MLConfig, %MLConfigFile%
		;MsgBox % MLConfig ; debug file content loading because it wouldn't work so many times for some reason
	;}
	;else {
		; This acts as a sanity check for the SA2 Mod Loader install, it's possible someone could be an idiot and install just the AP mod somehow
	;	MsgBox, 48, Error, Your SA2 Mod Loader is not configured or does not exist. Please ensure your SA2 Mod Loader is set up correctly.
	;	ExitApp
	;}
	; We check if there is a password and launch the text client accordingly, again using our variables.
	if (Password != "") {
		Run, "archipelago://%SlotName%:%Password%@%ServerURL%:%ServerPort%"
	}
	else {
		Run, "archipelago://%SlotName%:None@%ServerURL%:%ServerPort%"; Side note, again it is so dumb that we have to do this
	}
	; Check if the mod is loaded
	;if (InStr(MLConfig, "SA2B_Archipelago"))
	;{
		; We run the game and then exit the script.
		Run, "%SA2BInstall%\sonic2app.exe"
		ExitApp
	;} 
	;else
	;{
		; If the Config is not loading SA2B_Archipelago, then the user has to do that for the mod to work so we launch into the Mod Manager instead.
	;	MsgBox, 48, Notice, Your SA2 Mod Loader doesn't seem to be set up to run the SA2B_Archipelago mod.`nPlease enable the SA2B_Archipelago mod in your SA2 Mod Manager and then click Save & Play.
	;	Run, "%SA2BInstall%\SA2ModManager.exe"
;		ExitApp
	;}
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
