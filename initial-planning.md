Need to make a js that adds apsa2b:// link to any page on arcipelago.gg/room/* in the spot where the download/patch would go
 - Example url modeled after the archipelago:// urls
	- apsa2b://slotname:password@url:port

Need to make an ahk script with the following specs
 - When ran with no arguments, it will ask if you want to register it as a URL handler for apsa2b:// and offer an install/uninstall button
 - When ran with a apsa2b:// url as an argument it will handle the url by	
	- interpreting the url passed 
	- Editing config for SA2B AP with the new url and slot name password and saving it
	- launching the text client with the url and slot name
	- launching the game
	- ~~waiting for the game to close and also closing the text client~~
