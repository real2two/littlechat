RESET

$CONSOLE:ONLY

_DEST _CONSOLE

_CONSOLETITLE "Mini-Chat Host"
_TITLE "Mini-Chat Host" ' Shows the title of the progsram.

discord$ = "false"

IF discord$ = "true" THEN
    SHELL _DONTWAIT "node bot.js"
END IF

join$ = "true"

host = _OPENHOST("TCP/IP:7319") ' Opens Host
maxplayers = 10

IF host THEN
    PRINT "Host is ready!"
    DO
        '' Disable/Enable Joins | Disabled Due To Console.
        'k$ = INKEY$
        'IF k$ <> "" THEN
        '    IF k$ = "t" THEN
        '        IF join$ = "true" THEN
        '            join$ = "false"
        '        ELSE
        '            join$ = "true"
        '        END IF
        '    END IF
        'END IF

        ' Player Count + Leave Client
        loopnum = 0
        playercount = 0
        DO
            _DELAY 0.001
            loopnum = loopnum + 1
            IF connection&(loopnum) <> 0 THEN
                IF _CONNECTED(connection&(loopnum)) THEN
                    playercount = playercount + 1
                ELSE
                    IF leavemsg$(loopnum) <> "" THEN
                        PRINT leavemsg$(loopnum)
                        leavemsg$(loopnum) = ""
                    END IF
                END IF
            END IF
        LOOP UNTIL loopnum >= maxplayers

        _TITLE "Connections: " + _TRIM$(STR$(playercount)) + "/" + _TRIM$(STR$(maxplayers)) + " | Join: " + join$

        _DELAY 0.005

        ' Join Client
        connection& = _OPENCONNECTION(host) ' Gets a new open connection.
        IF connection& THEN ' Checks if there was a new open connection.
            IF join$ = "true" THEN
                loopnum = 0
                DO
                    _DELAY 0.05
                    loopnum = loopnum + 1

                    IF loopnum > maxplayers THEN ' If the new user cannot be connected.
                        PRINT _CONNECTIONADDRESS$(connection&) + " tried to join the connection." ' Alert Console
                        CLOSE connection& ' Closes the client connection.
                        GOTO endloginloop ' Ends loop.
                    END IF

                    IF connection&(loopnum) THEN ' If the connection handle exists.
                        IF connection&(loopnum) <> 0 AND _CONNECTED(connection&(loopnum)) THEN ' If someone is connected in the connection handle.
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
                        GOTO endloginloop ' Ends loop.
                    END IF
                LOOP
                endloginloop:
                loopnum = 0
            ELSE CLOSE connection&
            END IF
        END IF

        _DELAY 0.005

        ' Input Clients
        loopnum = 0
        DO
            _DELAY 0.05
            loopnum = loopnum + 1
            IF connection&(loopnum) <> 0 THEN
                IF _CONNECTED(connection&(loopnum)) THEN
                    _DELAY 0.005
                    GET connection&(loopnum), , output$
                    output$ = LEFT$(output$, 69)
                    IF output$ <> "" THEN
                        PRINT _CONNECTIONADDRESS$(connection&(loopnum)) + " | no." + _TRIM$(STR$(loopnum)) + " > " + output$
                        output$ = _TRIM$(STR$(loopnum)) + " | " + output$
                        ' Discord Bot Code
                        IF discord$ = "true" THEN
                            OPEN "data.txt" FOR OUTPUT AS #1
                            PRINT #1, output$
                            CLOSE #1
                        END IF
                        '''''''''''''''''
                        loopnum1 = 0
                        DO
                            loopnum1 = loopnum1 + 1
                            IF connection&(loopnum1) THEN ' If the connection handle exists.
                                IF connection&(loopnum1) <> 0 AND _CONNECTED(connection&(loopnum)) THEN ' If someone is connected in the connection handle.
                                    PUT connection&(loopnum1), , output$
                                END IF
                            END IF
                        LOOP UNTIL loopnum1 >= maxplayers
                    END IF
                END IF
            END IF
        LOOP UNTIL loopnum >= maxplayers
        loopnum = 0

        _DELAY 0.005
    LOOP
END IF
SYSTEM

