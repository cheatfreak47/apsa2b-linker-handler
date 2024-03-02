# SA2B Archipelago Instant Launch thing

Listen here. 

I'm lazy and don't wanna open SA2 Mod Loader every time. I wanna click a button and it just goes.

So I made this. All the code is pretty well commented and clear about how it works, feel free to explore it if you're apprehensive about using it.

**This is not officially supported or anything like that, I just share the things I write in case someone else may find it useful or something. Use if you wanna but don't go asking anyone for help or bothering anyone if you can't get it to work. The only place you should ask for help is in the issues section on this github page. Got it?**

# Usage:
 - Install [Sonic Adventure 2 from Steam](https://store.steampowered.com/app/213610/Sonic_Adventure_2/)
 - Install [Archipelago](https://archipelago.gg)
 - Set up the [SA2B Archipelago Mod](https://archipelago.gg/tutorial/Sonic%20Adventure%202%20Battle/setup/en)
 - Install your favorite userscript program on your default browser. (examples include: Tampermonkey, Violentmonkey, Greasemonkey, Firemonkey, etc)
 - Install the [userscript](https://raw.githubusercontent.com/cheatfreak47/apsa2b-linker-handler/main/APSA2BLinker.user.js) from this repo.
 - Download the Compiled Release or Compile the AutoHotKey script yourself.
 - Take the resulting `APSA2BHandler.exe` and put it in the Sonic Adventure 2 install folder or the Archipelago install folder.
 - Run `APSA2BHandler.exe` and click on Install to install the URL Handler.
 - That's it. To remove the URL Handler run the program again and choose Uninstall.

## Description for APSA2B Linker JS
Lazily uses jquery to read the `archipelago://` from the page and makes a new link using the `apsa2b://` url that contains the same data, in the download field that is usually unused.

## Description for APSA2B Handler AHK
- Must be compiled with ahk2exe with [AutoHotKey 1.1](https://www.autohotkey.com/download/ahk-install.exe) to be used because you cannot associate an ahk script with a url, only an executable file
- has an install/uninstall button for the URL handler when ran on it's own for easy install/uninstall
- updates the SA2B_Archipelago config.ini file with the needed data
- launches the text client for you too