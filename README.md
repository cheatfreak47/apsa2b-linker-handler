# SA2B Archipelago Instant Launch thing
Listen here. I'm lazy and don't wanna edit my config every time. I wanna click a button and it just goes.
So I made this.

This assumes you:
 - Have SA2B setup with the SA2B_Archipelago mod set up.
 - Have SA2 Mod Loader configured to launch the game as you like it with the mod loaded.

## APSA2B Linker JS
Lazily uses jquery to read the `archipelago://` from the page and makes a new link using the `apsa2b://` url that contains the same data, in the download field that is usually unused.

## URL Handler AHK Script

- Must be compiled with ahk2exe with [AutoHotKey 1.1](https://www.autohotkey.com/download/ahk-install.exe) to be used because you cannot associate an ahk script with a url, only an executable file
- has an install/uninstall button for the URL handler when ran on it's own for easy install/uninstall
- updates the SA2B_Archipelago config.ini file with the needed data
- launches the text client for you too