# Mini-Chat
A chat program I'm making with QB64.

[![](https://flat.badgen.net/github/issues/real2two/minichat)](https://github.com/real2two/minichat) [![](https://flat.badgen.net/github/stars/real2two/minichat)](https://github.com/real2two/minichat) [![](https://flat.badgen.net/github/commits/real2two/minichat)](https://github.com/real2two/minichat) [![](https://flat.badgen.net/github/last-commit/real2two/minichat)](https://github.com/real2two/minichat) [![Discord Chat](https://img.shields.io/discord/653413352063631391.svg?style=flat&logo=discord)](https://discord.gg/)

# Disclaimers
I do not take any responsiblities if your computer breaks or something while using the program. Logging the chat might take a lot of data.

# Host
There are 2 host files in the folder "host".
`host.exe` (code: `host.bas`) and `discordhost.exe` (code: `discordhost.bas`).

`install.bat` is required to run and `bot.js` (downloads discord.js) would be a required file if you use `discordhost.exe`, which is used for connecting the chat with Discord (read message only). 

For `bot.js`, you need to manually configure `const token = ""` and `const channelid = ""` in the code. The channel id is the channel you want to send messages from the chat program. The token is the Discord bot token.

Running any of the 2 host files will run the host. If you run it straight from the QB64 editor, you will get a console instead of a program, so you can scroll up and down and copy and paste, which I wish I can make it work when you open just the exe program. (it doesn't work for some reason)

The default port is "7319", but if you know how to code QB64, you know how to manually edit it.

You are able to just send random messages with the host if you know how to code QB64, so only let your friends and/or people who trust be able to use it, no one else.

# Client
There is one client file in the folder "client". This is used to connect to the host/server.
`client.bas` is the code and `client.exe` is the program.
"settings.txt" will automaticly me regenerated if there is a issue.
This should be the setup of `settings.txt`:
```
port of host
ip of host
image (leave blank for none)
color code for text
log chat or not (true/false)
```

# Hope you enjoy! :)
If you need help, join https://discord.gg/hf6QRcw (the official Discord chat). 


this readme is a huge wip and actually pretty bad - update soon.
