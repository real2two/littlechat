![](https://i.vgy.me/IcwEjs.png)
A chat program I'm making with QB64.

[![](https://flat.badgen.net/github/issues/real2two/minichat)](https://github.com/real2two/minichat) [![](https://flat.badgen.net/github/stars/real2two/minichat)](https://github.com/real2two/minichat) [![](https://flat.badgen.net/github/commits/real2two/minichat)](https://github.com/real2two/minichat) [![](https://flat.badgen.net/github/last-commit/real2two/minichat)](https://github.com/real2two/minichat) [![Discord Chat](https://img.shields.io/discord/653413352063631391.svg?style=flat&logo=discord)](https://discord.gg/)

### Disclaimers
* If something breaks, it's not our fault. We'll try our best to help, but it isn't our job to make everything perfect for you.
* All data transmitted and logged on your servers or systems is your fault, so if anything illegal happens don't come to us about it.
* Any issues with QB64 itself should be dealt with the proper team/developers - *not us*.

### Configuring the host.
There are 2 host files in the folder "host".
`host.exe` (code: `host.bas`) and `discordhost.exe` (code: `discordhost.bas`).

`install.bat` is required to run and `bot.js` (downloads discord.js) would be a required file if you use `discordhost.exe`, which is used for connecting the chat with Discord (read message only). 

For `bot.js`, you need to manually configure `const token = ""` and `const channelid = ""` in the code. The channel id is the channel you want to send messages from the chat program. The token is the Discord bot token.

Running any of the 2 host files will run the host. If you run it straight from the QB64 editor, you will get a console instead of a program, so you can scroll up and down and copy and paste, a feature that isn't currently working in the `.exe` program.

The default port is `7319`, but if you have experience with QB64 and want to change it, it won't break anything so feel free.
Please consider tweaking the code for any proper blacklist/whitelist system if you don't want anyone to be able to access your chat server without permission. This is **not** included by default.

### Client
There is one client file in the folder `client`. This is used to connect to the host/server.
`client.bas` is the code and `client.exe` is the program.
`settings.txt` will automaticly get regenerated if there is a issue.
This should be the setup of `settings.txt`:
```
port of host
ip of host
image (leave blank for none)
color code for text
log chat or not (true/false)
```

You can use [this](https://pastr.io/raw/KoGEtpSvb2A) configuration if you want to connect to our official server.

### Hope you enjoy! :)
If you need help, join https://discord.gg/Raa5Wz (the official Discord chat). 

