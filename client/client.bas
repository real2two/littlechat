resetClient:
CLS
RESET

$VERSIONINFO:CompanyName='LittleChat
$VERSIONINFO:FileDescription='A little chat program made with QB64.
$VERSIONINFO:InternalName='LittleChat Client
$VERSIONINFO:ProductName='LittleChat Client
$VERSIONINFO:Comments='This program is licensed with a MIT license.
$VERSIONINFO:FILEVERSION#=0,1,0,0

'SHELL _DONTWAIT "rundll32 url.dll,FileProtocolHandler https://www.google.com"'

IF _COMMANDCOUNT <> 0 THEN
    IF _COMMANDCOUNT = 1 THEN
        IF COMMAND$(1) = "help" THEN
            SCREEN _NEWIMAGE(550, 100, 32)
            _PRINTMODE _FILLBACKGROUND
            COLOR &HFFFFFFFF
            _TITLE "LittleChat Help"
            _PRINTSTRING (0, 0), CHR$(34) + "/help" + CHR$(34) + " - The help command."
            _PRINTSTRING (0, 15), CHR$(34) + "/say" + CHR$(34) + " - Send a message."
            _PRINTSTRING (0, 30), CHR$(34) + "/nick" + CHR$(34) + " - Change your username/nickname."
            _PRINTSTRING (0, 45), CHR$(34) + "/clipboard" + CHR$(34) + " - Send your clipboard to the chat. (you can Ctrl-V too)"
            _PRINTSTRING (0, 60), CHR$(34) + "/raw" + CHR$(34) + " - Send a raw message."
            _PRINTSTRING (0, 75), CHR$(34) + "/disconnect" + CHR$(34) + " - Disconnects from the server you are currently in."
            _DISPLAY
            SLEEP
            SYSTEM
        END IF
    END IF
END IF

$EXEICON:'.\icon.ico'

lines = 0

DIM SHARED lines$(24)
DIM SHARED newlines$(24)

_TITLE "LittleChat"
send$ = ""

SCREEN _NEWIMAGE(639, 400, 32)

IF _FILEEXISTS("settings.txt") THEN ' Read Settings
    OPEN "settings.txt" FOR INPUT AS #1 ' Open File
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings ' (will be repeated) Reset settings if there is a error.
    LINE INPUT #1, username$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, port$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, ip$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, image$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, iconimg$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, fgcolor$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, bgcolor$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, sound$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, log$
    CLOSE #1 ' Close the file.
ELSE
    resetSettings: ' Reset Settings On Error
    username$ = "Guest"
    port$ = "7319" ' Default Port
    ip$ = "localhost" ' Default IP
    image$ = ""
    iconimg$ = ""
    fgcolor$ = "FFFFFF"
    bgcolor$ = ""
    sound$ = ""
    log$ = "false"
    OPEN "settings.txt" FOR OUTPUT AS #1 ' Write Settings
    PRINT #1, username$
    PRINT #1, port$ ' Sets the first line of "settings.txt" as port$
    PRINT #1, ip$ ' Sets the second line of "settings.txt" as ip$
    PRINT #1, image$
    PRINT #1, iconimg$
    PRINT #1, fgcolor$
    PRINT #1, bgcolor$
    PRINT #1, sound$
    PRINT #1, log$
    CLOSE #1 ' Close the file.
END IF

IF log$ <> "true" AND log$ <> "false" GOTO resetSettings

IF sound$ <> "" THEN
    playsound& = _SNDOPEN(sound$)
    IF playsound& = 0 THEN SYSTEM
END IF

IF username$ = "" GOTO resetSettings
IF LEN(username$) >= 10 GOTO resetSettings

IF image$ <> "" THEN
    image& = _LOADIMAGE(image$, 32)
    IF image& < -1 THEN
    ELSE SYSTEM
    END IF
END IF

IF iconimg$ <> "" THEN
    iconimg& = _LOADIMAGE(iconimg$, 32)
    IF iconimg& < -1 THEN
        _ICON iconimg&
    ELSE SYSTEM
    END IF
    _FREEIMAGE iconimg&
END IF

IF bgcolor$ <> "" THEN
    _PRINTMODE _FILLBACKGROUND
    COLOR VAL("&HFF" + fgcolor$), VAL("&HFF" + bgcolor$)
ELSE
    _PRINTMODE _KEEPBACKGROUND
    COLOR VAL("&HFF" + fgcolor$)
END IF

1
IF image$ = "" THEN
ELSE
    _PUTIMAGE (0, 0), image&
END IF

client = _OPENCLIENT("TCP/IP:" + port$ + ":" + ip$) ' Opens Client
IF client THEN
    IF log$ = "true" THEN
        OPEN "log.txt" FOR APPEND AS #1
        PRINT #1, ""
        PRINT #1, "# client started at " + _TRIM$(TIME$) + "#"
        PRINT #1, ""
    END IF
    send$ = username$ + " has joined the chat."
    PUT client, , send$
    send$ = ""
    DO
        IF _CONNECTED(client) <> 0 THEN ' Checks constantly if the client works.
            IF _EXIT THEN
                endProgram:
                CLOSE #1
                send$ = username$ + " has left the chat."
                PUT client, , send$
                _SCREENHIDE
                _DELAY 2
                SYSTEM
            END IF

            k$ = ""
            k$ = INKEY$

            IF LEN(k$) = 1 THEN
                code = ASC(k$)
                IF code = 22 THEN
                    send$ = send$ + _CLIPBOARD$
                    GOTO endLoop
                END IF
                IF code = 8 THEN
                    send$ = LEFT$(send$, LEN(send$) - 1)
                ELSEIF code = 13 THEN
                    IF send$ <> "" THEN
                        IF send$ = "/disconnect" GOTO resetClient
                        IF LEFT$(send$, 5) = "/say " THEN send$ = RIGHT$(send$, LEN(send$) - 5): GOTO send
                        IF LEFT$(send$, 5) = "/raw " THEN send$ = RIGHT$(send$, LEN(send$) - 5): GOTO send1
                        IF send$ = "/help" THEN
                            SHELL _DONTWAIT "client.exe help"
                            send$ = ""
                            GOTO endLoop
                        END IF
                        IF LEFT$(send$, 6) = "/nick " THEN
                            oldusername$ = username$
                            IF LEFT$(RIGHT$(send$, LEN(send$) - 6), 10) <> RIGHT$(send$, LEN(send$) - 6) THEN GOTO send
                            username$ = LEFT$(RIGHT$(send$, LEN(send$) - 6), 10)
                            send$ = CHR$(34) + oldusername$ + CHR$(34) + " < changed his/her nickname to > " + CHR$(34) + username$ + CHR$(34)
                            PUT client, , send$
                            oldusername$ = ""
                            send$ = ""
                        ELSE
                            IF send$ = "/clipboard" THEN
                                send$ = _CLIPBOARD$
                            END IF
                            send:
                            send$ = username$ + ": " + send$
                            send1:
                            PUT client, , send$
                            send$ = ""
                        END IF
                    END IF
                ELSEIF code = 32 THEN
                    IF LEN(send$) <> 0 THEN
                        IF LEN(username$ + ": " + send$) <= 69 THEN
                            send$ = send$ + " "
                        END IF
                    END IF
                ELSE
                    IF LEN(username$ + ": " + send$) <= 69 THEN
                        send$ = send$ + _TRIM$(k$)
                    END IF
                END IF
            END IF
            endLoop:
            illegalCharacters send$

            CLS
            IF image$ = "" THEN
            ELSE
                _PUTIMAGE (0, 0), image&
            END IF

            GET client, , new$
            IF new$ <> "" THEN
                IF log$ = "true" THEN
                    PRINT #1, new$
                END IF
                lines$(24) = new$
                loopnum = 0
                DO
                    loopnum = loopnum + 1
                    newlines$(loopnum) = lines$(loopnum + 1)
                LOOP UNTIL loopnum >= 23
                loopnum = 0
                DO
                    loopnum = loopnum + 1
                    lines$(loopnum) = newlines$(loopnum)
                LOOP UNTIL loopnum >= 23
                IF sound$ <> "" THEN
                    _SNDPLAY playsound&
                END IF
            END IF
            loopnum = 0
            DO
                loopnum = loopnum + 1
                IF lines$(loopnum) <> "" THEN
                    PRINT lines$(loopnum)
                END IF
            LOOP UNTIL loopnum >= 23
            _PRINTSTRING (0, 375), "> " + send$
            _DISPLAY
        ELSE SYSTEM
        END IF
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

SUB illegalCharacters (inputcode$)
    done = 0
    text$ = ""
    test1$ = inputcode$
    test$ = LCASE$(inputcode$)
    DO
        IF LEFT$(test$, 1) = " " OR LEFT$(test$, 1) = "a" OR LEFT$(test$, 1) = "b" OR LEFT$(test$, 1) = "c" OR LEFT$(test$, 1) = "d" OR LEFT$(test$, 1) = "e" OR LEFT$(test$, 1) = "f" OR LEFT$(test$, 1) = "g" OR LEFT$(test$, 1) = "h" OR LEFT$(test$, 1) = "i" OR LEFT$(test$, 1) = "j" OR LEFT$(test$, 1) = "k" OR LEFT$(test$, 1) = "l" OR LEFT$(test$, 1) = "m" OR LEFT$(test$, 1) = "n" OR LEFT$(test$, 1) = "o" OR LEFT$(test$, 1) = "p" OR LEFT$(test$, 1) = "q" OR LEFT$(test$, 1) = "r" OR LEFT$(test$, 1) = "s" OR LEFT$(test$, 1) = "t" OR LEFT$(test$, 1) = "u" OR LEFT$(test$, 1) = "v" OR LEFT$(test$, 1) = "w" OR LEFT$(test$, 1) = "x" OR LEFT$(test$, 1) = "y" OR LEFT$(test$, 1) = "z" OR LEFT$(test$, 1) = "1" OR LEFT$(test$, 1) = "2" OR LEFT$(test$, 1) = "3" OR LEFT$(test$, 1) = "4" OR LEFT$(test$, 1) = "5" OR LEFT$(test$, 1) = "6" OR LEFT$(test$, 1) = "7" OR LEFT$(test$, 1) = "8" OR LEFT$(test$, 1) = "9" OR LEFT$(test$, 1) = "0" OR LEFT$(test$, 1) = "`" OR LEFT$(test$, 1) = "~" OR LEFT$(test$, 1) = "!" OR LEFT$(test$, 1) = "@" OR LEFT$(test$, 1) = "#" OR LEFT$(test$, 1) = "$" OR LEFT$(test$, 1) = "%" OR LEFT$(test$, 1) = "^" OR LEFT$(test$, 1) = "&" OR LEFT$(test$, 1) = "*" OR LEFT$(test$, 1) = "(" OR LEFT$(test$, 1) = ")" OR LEFT$(test$, 1) = "-" OR LEFT$(test$, 1) = "_" OR LEFT$(test$, 1) = "+" OR LEFT$(test$, 1) = "=" OR LEFT$(test$, 1) = "[" OR LEFT$(test$, 1) = "{" OR LEFT$(test$, 1) = "]" OR LEFT$(test$, 1) = "}" OR LEFT$(test$, 1) = "|" OR LEFT$(test$, 1) = "\" OR LEFT$(test$, 1) = ";" OR LEFT$(test$, 1) = ":" OR LEFT$(test$, 1) = "'" OR LEFT$(test$, 1) = "<" OR LEFT$(test$, 1) = "," OR LEFT$(test$, 1) = ">" OR LEFT$(test$, 1) = "." OR LEFT$(test$, 1) = "?" OR LEFT$(test$, 1) = "/" OR LEFT$(test$, 1) = CHR$(34) THEN
            text$ = text$ + LEFT$(test1$, 1)
        END IF
        test$ = RIGHT$(test$, LEN(test$) - 1)
        test1$ = RIGHT$(test1$, LEN(test1$) - 1)
        IF test$ = "" THEN done = 1
    LOOP UNTIL done = 1
    inputcode$ = text$
END SUB

