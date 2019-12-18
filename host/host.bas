RESET

'$CONSOLE:ONLY

'_DEST _CONSOLE

'_CONSOLETITLE "LittleChat Host"

_TITLE "LittleChat Host" ' Shows the title of the progsram.

IF _FILEEXISTS("settings.txt") THEN ' Read Settings
    OPEN "settings.txt" FOR INPUT AS #1 ' Open File
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, port$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, maxplayers$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, log$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, antidoubleip$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, usernotest$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, discord$
    IF discord$ = "true" THEN
        IF EOF(1) THEN CLOSE #1: GOTO resetSettings
        LINE INPUT #1, discord.token$
        IF EOF(1) THEN CLOSE #1: GOTO resetSettings
        LINE INPUT #1, discord.botid$
        IF EOF(1) THEN CLOSE #1: GOTO resetSettings
        LINE INPUT #1, discord.channelid$
    END IF
    CLOSE #1 ' Close the file.
ELSE
    resetSettings: ' Reset Settings On Error
    port$ = "7319" ' Default Port
    maxplayers$ = "10"
    log$ = "false"
    antidoubleip$ = "false"
    usernotest$ = "true"
    discord$ = "false"
    discord.token$ = ""
    discord.channelid$ = ""
    discord.botid$ = ""
    OPEN "settings.txt" FOR OUTPUT AS #1 ' Write Settings
    PRINT #1, port$
    PRINT #1, maxplayers$
    PRINT #1, log$
    PRINT #1, antidoubleip$
    PRINT #1, usernotest$
    PRINT #1, discord$
    CLOSE #1 ' Close the file.
END IF

IF log$ <> "true" AND log$ <> "false" GOTO resetSettings
IF antidoubleip$ <> "true" AND antidoubleip$ <> "false" GOTO resetSettings
IF usernotest$ <> "true" AND usernotest$ <> "false" GOTO resetSettings
IF discord$ <> "true" AND discord$ <> "false" GOTO resetSettings

maxplayers = VAL(maxplayers$)
IF maxplayers <= 0 GOTO resetSettings
port = VAL(port$)
IF port <= 0 GOTO resetSettings

join$ = "true"
olddiscordmsg$ = ""
'illegal1$ = CHR$(13)
'illegal2$ = CHR$(10)

host = _OPENHOST("TCP/IP:" + _TRIM$(STR$(port))) ' Opens Host

DIM connection&(maxplayers)
DIM leavemsg$(maxplayers)
DIM players$(maxplayers)
DIM lastmsg$(maxplayers)
IF antidoubleip$ = "true" THEN
    DIM ip$(maxplayers)
END IF

kick$ = "false"

IF host THEN
    IF _FILEEXISTS("send.txt") THEN
        KILL "send.txt"
    END IF
    IF log$ = "true" THEN
        OPEN "log.txt" FOR APPEND AS #1
        PRINT #1, ""
        PRINT #1, "# host started at " + _TRIM$(TIME$) + "#"
        PRINT #1, ""
    END IF

    PRINT "Host is ready!"
    IF log$ = "true" THEN
        PRINT #1, "Host is ready!"
    END IF

    IF discord$ = "true" THEN
        IF discord.token$ <> "" AND discord.channelid$ <> "" AND discord.botid$ <> "" THEN
            PRINT "Generating bot.js (if you don't have node.js, the Discord option won't work)"
            IF log$ = "true" THEN
                PRINT #1, "Generating bot.js (if you don't have node.js, the Discord option won't work)"
            END IF
            OPEN "bot.js" FOR OUTPUT AS #1
            PRINT #1, "const fs = require('fs');"
            PRINT #1, "const Discord = require('discord.js');"
            PRINT #1, "const client = new Discord.Client();"
            PRINT #1, "const token = '" + discord.token$ + "';"
            PRINT #1, "const channelid = '" + discord.channelid$ + "';"
            PRINT #1, "const botid = '" + discord.botid$ + "';"
            PRINT #1, "client.on('ready', () => {"
            PRINT #1, "  console.log('Bot is ready!');"
            PRINT #1, "  client.user.setActivity('people chat.', { type: 'WATCHING'});"
            PRINT #1, "  newone(client);"
            PRINT #1, "})"
            PRINT #1, "client.on('message', message => {"
            PRINT #1, "  try {"
            PRINT #1, "    if (message.author.id === botid) return;"
            PRINT #1, "    if (message.channel.id === channelid) {"
            PRINT #1, "      message.delete();"
            PRINT #1, "      fs.writeFile('send.txt', 'Discord | ' + message.member.user.tag.toString() + ' | ' + message.content.toString(), function(err) {"
            PRINT #1, "      if (err) throw err;"
            PRINT #1, "      });"
            PRINT #1, "    }"
            PRINT #1, "  } catch(err) {"
            PRINT #1, "    console.log(err);"
            PRINT #1, "  }"
            PRINT #1, "});"
            PRINT #1, "function newone(client) {"
            PRINT #1, "  if (fs.existsSync('data.txt')) {"
            PRINT #1, "    msg = fs.readFileSync('data.txt').toString();"
            PRINT #1, "    fs.unlink('data.txt', function (err) {"
            PRINT #1, "    if (err) throw err;"
            PRINT #1, "    });"
            PRINT #1, "    const embed = new Discord.RichEmbed()"
            PRINT #1, "      .setColor('RANDOM')"
            PRINT #1, "      .setDescription(msg)"
            PRINT #1, "    client.channels.get(channelid).send(embed);"
            PRINT #1, "  }"
            PRINT #1, "  setTimeout(function(){"
            PRINT #1, "    newone(client);"
            PRINT #1, "  }, 1000)"
            PRINT #1, "}"
            PRINT #1, "client.login(token)"
            CLOSE #1
            IF _DIREXISTS(".\node_modules\discord.js") THEN
            ELSE
                PRINT "Trying to install the npm discord.js. (could not detect npm)"
                IF log$ = "true" THEN
                    PRINT #1, "Trying to install the npm discord.js. (could not detect npm)"
                END IF
                SHELL "npm install discord.js"
            END IF
            PRINT "Trying to turn on the Discord bot. (This opens an external program.)"
            IF log$ = "true" THEN
                PRINT #1, "Trying to turn on the Discord bot. (This opens an external program.)"
            END IF
            SHELL _DONTWAIT "node bot.js"
        ELSE GOTO resetSettings
        END IF
    END IF

    DO
        ' Close the program.
        IF _EXIT THEN
            CLOSE #1
            SYSTEM
        END IF
        ' Disable/Enable Joins
        k$ = INKEY$
        IF k$ <> "" THEN
            'IF kick$ = "true" THEN
            '    code = ASC(k$)
            '    IF k$ = "1" OR k$ = "2" OR k$ = "3" OR k$ = "4" OR k$ = "5" OR k$ = "6" OR k$ = "7" OR k$ = "8" OR k$ = "9" OR k$ = "0" THEN
            '        IF LEN(kickmsg$) >= LEN(_TRIM$(STR$(maxplayers))) THEN
            '        ELSE
            '            kickmsg$ = kickmsg$ + _TRIM$(k$)
            '            GOTO endToggleLoop
            '        END IF
            '    ELSEIF code = 13 THEN
            '        kickmsg = VAL(kickmsg$)
            '        IF leavemsg$(kickmsg) <> "" THEN
            '            IF connection&(kickmsg) <> 0 THEN
            '                IF _CONNECTED(connection&(kickmsg)) THEN
            '                    IF antidoubleip$ = "true" THEN
            '                        ip$(kickmsg) = ""
            '                    END IF
            '                    output$ = "Host | no." + _TRIM$(STR$(kickmsg)) + " has been kicked from the server."
            '                    PRINT output$
            '                    IF log$ = "true" THEN
            '                        PRINT #1, output$
            '                    END IF
            '                    loopnum = 0
            '                    DO
            '                        loopnum = loopnum + 1
            '                        IF connection&(loopnum) <> 0 THEN
            '                            IF _CONNECTED(connection&(loopnum)) THEN ' If someone is connected in the connection handle.
            '                                PUT connection&(loopnum), , output$
            '                            END IF
            '                        END IF
            '                    LOOP UNTIL loopnum >= maxplayers
            '                    CLOSE connection&(kickmsg)
            '                END IF
            '            END IF
            '        END IF
            '        kickmsg = 0
            '        kickmsg$ = ""
            '        kick$ = "false"
            '        GOTO endToggleLoop
            '    ELSEIF code = 8 THEN
            '        kickmsg$ = LEFT$(kickmsg$, LEN(kickmsg$) - 1)
            '        GOTO endToggleLoop
            '    END IF
            'END IF
            IF k$ = "t" THEN
                IF join$ = "true" THEN
                    join$ = "false"
                ELSE
                    join$ = "true"
                END IF
            ELSEIF k$ = "k" THEN
                kick$ = "true"
                kickmsg$ = ""
            END IF
        END IF
        endToggleLoop:

        'IF kick$ = "true" THEN
        '    _TITLE "Who should I kick: no." + kickmsg$
        'END IF

        ' Player Count + Leave Client
        loopnum = 0
        playercount = 0
        DO
            loopnum = loopnum + 1
            IF connection&(loopnum) <> 0 THEN
                IF _CONNECTED(connection&(loopnum)) THEN
                    playercount = playercount + 1
                ELSE
                    IF leavemsg$(loopnum) <> "" THEN
                        PRINT leavemsg$(loopnum)
                        leavemsg$(loopnum) = ""
                        IF antidoubleip$ = "true" THEN
                            ip$(maxplayers) = ""
                        END IF
                    END IF
                END IF
            END IF
        LOOP UNTIL loopnum >= maxplayers

        IF kick$ = "false" THEN
            _TITLE "Connections: " + _TRIM$(STR$(playercount)) + "/" + _TRIM$(STR$(maxplayers)) + " | Join: " + join$
        END IF

        '_DELAY 0.005

        ' Join Client
        connection& = _OPENCONNECTION(host) ' Gets a new open connection.
        IF connection& THEN ' Checks if there was a new open connection.
            IF join$ = "true" THEN
                IF antidoubleip$ = "true" OR _FILEEXISTS("ipbans.txt") THEN
                    testip$ = _CONNECTIONADDRESS$(connection&)
                    testipj$ = testip$
                    CALL loopUntil(testipj$, ":", testip$)
                    CALL loopUntil(testipj$, ":", testip$)
                    testip$ = _TRIM$(testipj$)
                    testipj$ = ""
                    IF _FILEEXISTS("ipbans.txt") THEN
                        OPEN "ipbans.txt" FOR INPUT AS #2
                        IF EOF(2) THEN CLOSE #2: GOTO skipipban
                        DO
                            LINE INPUT #2, ip$
                            IF ip$ = testip$ THEN
                                PRINT _CONNECTIONADDRESS$(connection&) + " tried to join, but is ip banned." ' Alert Console
                                CLOSE connection& ' Closes the client connection.
                                CLOSE #2
                                GOTO endloginLoop
                            END IF
                        LOOP UNTIL EOF(2)
                        CLOSE #2
                    END IF
                    skipipban:
                    IF antidoubleip$ = "true" THEN
                        loopnum = 0
                        DO
                            loopnum = loopnum + 1
                            IF ip$(loopnum) = testip$ THEN
                                PRINT _CONNECTIONADDRESS$(connection&) + " tried to join with two connections." ' Alert Console
                                CLOSE connection& ' Closes the client connection.
                                GOTO endloginLoop
                            END IF
                        LOOP UNTIL loopnum >= maxplayers
                    END IF
                END IF
                loopnum = 0
                DO
                    '_DELAY 0.05
                    loopnum = loopnum + 1

                    IF loopnum > maxplayers THEN ' If the new user cannot be connected.
                        PRINT _CONNECTIONADDRESS$(connection&) + " tried to join the connection." ' Alert Console
                        CLOSE connection& ' Closes the client connection.
                        GOTO endloginLoop ' Ends loop.
                    END IF

                    IF connection&(loopnum) THEN ' If the connection handle exists.
                        IF connection&(loopnum) <> 0 THEN
                            IF _CONNECTED(connection&(loopnum)) THEN ' If someone is connected in the connection handle.
                            ELSE
                                CLOSE connection&(loopnum) ' Close the connection.
                                GOTO setloginconnection ' Do all the connection add stuff.
                            END IF
                        ELSE
                            CLOSE connection&(loopnum) ' Close the connection.
                            GOTO setloginconnection ' Do all the connection add stuff.
                        END IF
                    ELSE
                        setloginconnection: ' Doing the connection add stuff.
                        connection&(loopnum) = connection& ' Setting the connection handle.
                        players$(loopnum) = "" ' Clears their username.
                        PRINT _CONNECTIONADDRESS$(connection&) + " has joined the connection." ' Alert Console
                        leavemsg$(loopnum) = _CONNECTIONADDRESS$(connection&) + " has left the connection."
                        IF antidoubleip$ = "true" THEN
                            ip$(maxplayers) = testip$
                        END IF
                        GOTO endloginLoop ' Ends loop.
                    END IF
                LOOP
                endloginLoop:
                loopnum = 0
            ELSE CLOSE connection&
            END IF
        END IF

        '_DELAY 0.005

        ' Input Clients
        loopnum = 0
        DO
            '_DELAY 0.05
            loopnum = loopnum + 1
            IF connection&(loopnum) <> 0 THEN
                IF _CONNECTED(connection&(loopnum)) THEN
                    '_DELAY 0.005
                    GET connection&(loopnum), , output$
                    output$ = _TRIM$(LEFT$(_TRIM$(output$), 69))
                    IF output$ <> "" THEN
                        IF _FILEEXISTS("banwords.txt") THEN
                            OPEN "banwords.txt" FOR INPUT AS #2
                            IF EOF(2) GOTO skipbanwords
                            DO
                                LINE INPUT #2, banwords$
                                test$ = output$
                                DO
                                    IF LEFT$(LCASE$(test$), LEN(banwords$)) = LCASE$(banwords$) THEN
                                        CLOSE #2
                                        GOTO resetInputLoop
                                    ELSE
                                        test$ = RIGHT$(test$, LEN(test$) - 1)
                                    END IF
                                LOOP UNTIL test$ = ""
                            LOOP UNTIL EOF(2)
                            CLOSE #2
                        END IF
                        skipbanwords:
                        IF output$ = lastmsg$(loopnum) GOTO resetInputLoop
                        'Replace output$, illegal1$, "?"
                        'Replace output$, illegal2$, "?"
                        illegalCharacters output$
                        lastmsg$(loopnum) = output$
                        consoleoutput$ = _CONNECTIONADDRESS$(connection&(loopnum)) + " | no." + _TRIM$(STR$(loopnum)) + " > " + output$
                        PRINT consoleoutput$
                        IF log$ = "true" THEN
                            PRINT #1, consoleoutput$
                        END IF
                        IF usernotest$ = "true" THEN
                            output$ = _TRIM$(STR$(loopnum)) + " | " + output$
                        END IF
                        OPEN "data.txt" FOR OUTPUT AS #2
                        PRINT #2, output$
                        CLOSE #2
                        loopnum1 = 0
                        DO
                            loopnum1 = loopnum1 + 1
                            IF connection&(loopnum1) THEN ' If the connection handle exists.
                                IF connection&(loopnum1) <> 0 THEN
                                    IF _CONNECTED(connection&(loopnum1)) THEN ' If someone is connected in the connection handle.
                                        PUT connection&(loopnum1), , output$
                                    END IF
                                END IF
                            END IF
                        LOOP UNTIL loopnum1 >= maxplayers
                    END IF
                END IF
            END IF
            resetInputLoop:
        LOOP UNTIL loopnum >= maxplayers
        loopnum = 0

        '_DELAY 0.005

        IF _FILEEXISTS("send.txt") THEN
            discordmsg$ = ""
            OPEN "send.txt" FOR INPUT AS #2
            IF EOF(2) THEN CLOSE #2: GOTO endSend
            LINE INPUT #2, discordmsg$
            CLOSE #2
            discordmsg$ = _TRIM$(LEFT$(_TRIM$(discordmsg$), 69))
            IF discordmsg$ <> olddiscordmsg$ THEN
                olddiscordmsg$ = discordmsg$
                output$ = discordmsg$
                PRINT output$
                IF log$ = "true" THEN
                    PRINT #1, output$
                END IF
                OPEN "data.txt" FOR OUTPUT AS #2
                PRINT #2, output$
                CLOSE #2
                loopnum1 = 0
                DO
                    loopnum1 = loopnum1 + 1
                    IF connection&(loopnum1) THEN ' If the connection handle exists.
                        IF connection&(loopnum1) <> 0 THEN
                            IF _CONNECTED(connection&(loopnum1)) THEN ' If someone is connected in the connection handle.
                                PUT connection&(loopnum1), , output$
                            END IF
                        END IF
                    END IF
                LOOP UNTIL loopnum1 >= maxplayers
            END IF
        END IF
        endSend:
    LOOP
END IF
SYSTEM

SUB loopUntil (text$, until$, new$)
    IF LEN(until$) = 1 THEN
        test$ = text$
        new$ = ""
        done = 0
        DO
            IF test$ <> "" THEN
                IF LEFT$(test$, 1) = until$ THEN
                    test$ = RIGHT$(test$, LEN(test$) - 1)
                    text$ = test$
                    done = 1
                ELSE
                    new$ = new$ + LEFT$(test$, 1)
                    test$ = RIGHT$(test$, LEN(test$) - 1)
                END IF
            ELSE
                text$ = ""
                done = 1
            END IF
        LOOP UNTIL done = 1
        done = 0
    END IF
END SUB

'SUB Replace (text$, old$, new$)
'    test$ = text$
'    text$ = ""
'    DO
'        IF LEFT$(text$, LEN(old$)) = old$ THEN
'            test$ = RIGHT$(test$, LEN(test$) - LEN(old$))
'            text$ = text$ + new$
'        ELSE
'            text$ = text$ + LEFT$(test$, 1)
'            test$ = RIGHT$(test$, LEN(test$) - 1)
'        END IF
'    LOOP UNTIL test$ = ""
'END SUB

SUB illegalCharacters (inputcode$)
    done = 0
    text$ = ""
    test1$ = inputcode$
    test$ = LCASE$(inputcode$)
    DO
        IF LEFT$(test$, 1) = " " OR LEFT$(test$, 1) = "a" OR LEFT$(test$, 1) = "b" OR LEFT$(test$, 1) = "c" OR LEFT$(test$, 1) = "d" OR LEFT$(test$, 1) = "e" OR LEFT$(test$, 1) = "f" OR LEFT$(test$, 1) = "g" OR LEFT$(test$, 1) = "h" OR LEFT$(test$, 1) = "i" OR LEFT$(test$, 1) = "j" OR LEFT$(test$, 1) = "k" OR LEFT$(test$, 1) = "l" OR LEFT$(test$, 1) = "m" OR LEFT$(test$, 1) = "n" OR LEFT$(test$, 1) = "o" OR LEFT$(test$, 1) = "p" OR LEFT$(test$, 1) = "q" OR LEFT$(test$, 1) = "r" OR LEFT$(test$, 1) = "s" OR LEFT$(test$, 1) = "t" OR LEFT$(test$, 1) = "u" OR LEFT$(test$, 1) = "v" OR LEFT$(test$, 1) = "w" OR LEFT$(test$, 1) = "x" OR LEFT$(test$, 1) = "y" OR LEFT$(test$, 1) = "z" OR LEFT$(test$, 1) = "1" OR LEFT$(test$, 1) = "2" OR LEFT$(test$, 1) = "3" OR LEFT$(test$, 1) = "4" OR LEFT$(test$, 1) = "5" OR LEFT$(test$, 1) = "6" OR LEFT$(test$, 1) = "7" OR LEFT$(test$, 1) = "8" OR LEFT$(test$, 1) = "9" OR LEFT$(test$, 1) = "0" OR LEFT$(test$, 1) = "`" OR LEFT$(test$, 1) = "~" OR LEFT$(test$, 1) = "!" OR LEFT$(test$, 1) = "@" OR LEFT$(test$, 1) = "#" OR LEFT$(test$, 1) = "$" OR LEFT$(test$, 1) = "%" OR LEFT$(test$, 1) = "^" OR LEFT$(test$, 1) = "&" OR LEFT$(test$, 1) = "*" OR LEFT$(test$, 1) = "(" OR LEFT$(test$, 1) = ")" OR LEFT$(test$, 1) = "-" OR LEFT$(test$, 1) = "_" OR LEFT$(test$, 1) = "+" OR LEFT$(test$, 1) = "=" OR LEFT$(test$, 1) = "[" OR LEFT$(test$, 1) = "{" OR LEFT$(test$, 1) = "]" OR LEFT$(test$, 1) = "}" OR LEFT$(test$, 1) = "|" OR LEFT$(test$, 1) = "\" OR LEFT$(test$, 1) = ";" OR LEFT$(test$, 1) = ":" OR LEFT$(test$, 1) = "'" OR LEFT$(test$, 1) = "<" OR LEFT$(test$, 1) = "," OR LEFT$(test$, 1) = ">" OR LEFT$(test$, 1) = "." OR LEFT$(test$, 1) = "?" OR LEFT$(test$, 1) = "/" OR LEFT$(test$, 1) = CHR$(34) THEN
            text$ = text$ + LEFT$(test1$, 1)
        ELSE
            text$ = text$ + "?"
        END IF
        test$ = RIGHT$(test$, LEN(test$) - 1)
        test1$ = RIGHT$(test1$, LEN(test1$) - 1)
        IF test$ = "" THEN done = 1
    LOOP UNTIL done = 1
    inputcode$ = text$
END SUB
