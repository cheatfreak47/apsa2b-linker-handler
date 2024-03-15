# SA2B Archipelago Instant Launch thing
Listen here. I'm lazy and don't wanna open SA2 Mod Loader every time. I wanna click a button and it all just does it for me.


https://github.com/cheatfreak47/apsa2b-linker-handler/assets/7818664/b88c83fb-f4d2-49ad-8fb8-0477711d5899


So I made this. All the code is pretty well commented and clear about how it works, but do note it's obviously not official or officially supported or anything. Don't go bothering anyone but me in the issues section about it.

# Usage:
 - Install [Sonic Adventure 2 from Steam](https://store.steampowered.com/app/213610/Sonic_Adventure_2/)
 - Install [Archipelago](https://archipelago.gg)
 - Set up the [SA2B Archipelago Mod](https://archipelago.gg/tutorial/Sonic%20Adventure%202%20Battle/setup/en)
 - Install your favorite userscript extension on your default browser. (examples include: Tampermonkey, Violentmonkey, Greasemonkey, Firemonkey, etc) My favorite is [FireMonkey on Firefox](https://addons.mozilla.org/en-US/firefox/addon/firemonkey/).
 - Install the [userscript](https://raw.githubusercontent.com/cheatfreak47/apsa2b-linker-handler/main/APSA2BLinker.user.js) from this repo.
 - Download the and un7z the [compiled release](https://github.com/cheatfreak47/apsa2b-linker-handler/releases) or compile `APSA2BHandler.ahk` from the repository yourself.
 - Take the resulting `APSA2BHandler.exe` and put it in the Sonic Adventure 2 install folder or the Archipelago install folder.
 - Run `APSA2BHandler.exe` and click on Install to install the URL Handler.
 - That's it. To remove the URL Handler run the program again and choose Uninstall.

## How it works for people who don't read code
Basically it registers a new URL type that when you click on it, runs a program that configures your SA2B_Archipelago mod for you, loads up the Text Client, and Launches the game for you. The new URLs are added to the page by a userscript you install in a userscript browser extension. That's it.

## Description for APSA2B Linker JS
![Image of Linker in Action](https://raw.githubusercontent.com/cheatfreak47/apsa2b-linker-handler/main/APSA2BLinker.png)

Lazily uses jquery to read the `archipelago://` from the page and makes a new link using the `apsa2b://` url that contains the same data, in the download field that is usually unused.

## Description for APSA2B Handler AHK
![Image of URL Handler](https://raw.githubusercontent.com/cheatfreak47/apsa2b-linker-handler/main/APSA2BHandler.png)
 - Must be compiled with ahk2exe from [AutoHotKey 1.1](https://www.autohotkey.com/download/ahk-install.exe) to be used because you cannot associate an ahk script with a url, only an executable file.
 - If you use ahk2exe manually to compile, you can customize the icon like the release version to use the `icon.ico` from `C:\ProgramData\Archipelago\Data\`. My build script also does this.
 - has an install/uninstall button for the URL handler when ran on it's own for easy install/uninstall
 - has some very basic error handling
 - updates the SA2B_Archipelago config.ini file with the needed data passed by the clicked url
 - launches the text client for you
 - launches the game for you
