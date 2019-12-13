RESET

lines = 0

DIM SHARED lines$(24)
DIM SHARED newlines$(24)

_TITLE "Mini-Chat"
send$ = ""

SCREEN _NEWIMAGE(639, 400, 32)

IF _FILEEXISTS("settings.txt") THEN ' Read Settings
    OPEN "settings.txt" FOR INPUT AS #1 ' Open File
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings ' (will be repeated) Reset settings if there is a error.
    LINE INPUT #1, port$ ' First line of "settings.txt" is the port of the game you join.
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, ip$ ' Second line of "settings.txt" is the ip of the game you join.
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, image$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, color$
    IF EOF(1) THEN CLOSE #1: GOTO resetSettings
    LINE INPUT #1, log$
    CLOSE #1 ' Close the file.
ELSE
    resetSettings: ' Reset Settings On Error
    port$ = "7319" ' Default Port
    ip$ = "localhost" ' Default IP
    image$ = ""
    color$ = "FFFFFF"
    log$ = "false"
    OPEN "settings.txt" FOR OUTPUT AS #1 ' Write Settings
    PRINT #1, port$ ' Sets the first line of "settings.txt" as port$
    PRINT #1, ip$ ' Sets the second line of "settings.txt" as ip$
    PRINT #1, image$
    PRINT #1, color$
    PRINT #1, log$
    CLOSE #1 ' Close the file.
END IF

IF log$ <> "true" AND log$ <> "false" GOTO resetSettings

IF image$ <> "" THEN
    image& = _LOADIMAGE(image$, 32)
    IF image& < -1 THEN
    ELSE SYSTEM
    END IF
END IF


COLOR VAL("&HFF" + color$)
_PRINTMODE _KEEPBACKGROUND

1
CLS
IF image$ = "" THEN
ELSE
    _PUTIMAGE (0, 0), image&
END IF

LINE INPUT "What is your username: ", username$
IF username$ = "" GOTO 1
IF LEN(username$) >= 10 GOTO 1
CLS

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

            IF k$ <> "" THEN
                code = ASC(k$)
                IF code = 22 THEN
                    send$ = send$ + _CLIPBOARD$
                    GOTO endLoop
                END IF
                IF code = 8 THEN
                    send$ = LEFT$(send$, LEN(send$) - 1)
                ELSEIF code = 13 THEN
                    IF send$ <> "" THEN
                        IF LEFT$(send$, 5) = "/say " THEN send$ = RIGHT$(send$, LEN(send$) - 5): GOTO send
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
                            PUT client, , send$
                            send$ = ""
                        END IF
                    END IF
                ELSEIF code = 32 THEN
                    IF LEN(username$ + ": " + send$) <= 69 THEN
                        send$ = send$ + " "
                    END IF
                ELSE
                    IF LEN(username$ + ": " + send$) <= 69 THEN
                        send$ = send$ + _TRIM$(k$)
                    END IF
                END IF
            END IF
            endLoop:

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
