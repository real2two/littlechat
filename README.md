# Mini-Chat
A chat program I'm making with QB64.

# Disclaimers
I do not take any responsiblities if your computer breaks or something while using the program. Logging the chat might take a lot of data.

# Host
There are 2 host files in the folder "host".
`host.exe` (code: `host.bas`) and `discordhost.exe` (code: `discordhost.bas`).

`install.bat` is required to run and `bot.js` (downloads discord.js) would be a required file if you use `discordhost.exe`, which is used for connecting the chat with Discord (read message only). 

For `bot.js`, you need to manually configure `const token = ""` and `const channelid = ""` in the code. The channel id is the channel you want to send messages from the chat program. The token is the Discord bot token.

Running any of the 2 host files will run the host. If you run it straight from the QB64 editor, you will get a console instead of a program, so you can scroll up and down and copy and paste, which I wish I can make it work when you open just the exe program. (it doesn't work for some reason)

The default port is "7319", but if you know how to code QB64, you know how to manually edit it.
