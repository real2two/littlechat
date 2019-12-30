$CONSOLE:ONLY
_DEST _CONSOLE

crlf$ = CHR$(13) + CHR$(10)
dd = _OPENHOST("TCP/IP:80")
IF dd = 0 THEN BEEP: COLOR 15: PRINT "Unable to create server on port 80 (already port used?)": END

client = _OPENCLIENT("TCP/IP:7319:localhost")
DIM msg$(12)
DIM oldmsg$(12)

PRINT "Mini web server"
PRINT "Press ESC Key to shutdown server"
PRINT " "
PRINT "To test your server, type HTTP://127.0.0.1/ in your web browser"
PRINT "when the server is running."
PRINT
COLOR 15: PRINT "[No connection] "

DO
    c = _OPENCONNECTION(dd)
    IF c <> 0 THEN
        addr$ = _CONNECTIONADDRESS(c)
        COLOR 15: PRINT "Client connected: ";: COLOR 12: PRINT addr$

        GET #c, , x$

        a = INSTR(x$, "GET ")
        b = INSTR(a + 5, x$, " ")
        request$ = RIGHT$(LEFT$(x$, b - 1), b - a - 4)
        COLOR 14, 8
        PRINT "request = ";
        COLOR 0, 7: PRINT request$
        IF LEN(request$) = 0 THEN PRINT x$
        COLOR 7, 0

        SELECT CASE request$
            CASE "/"
                main:
                request$ = ""
                junk$ = ""
                IF _FILEEXISTS(".\index.html") THEN
                    ff = FREEFILE
                    OPEN "index.html" FOR BINARY AS #ff
                    a$ = SPACE$(LOF(ff))
                    GET #ff, 1, a$
                    CLOSE ff
                    reply$ = "HTTP/1.0 200 OK" + crlf$ + crlf$
                    reply$ = reply$ + a$
                ELSE GOTO unknownPage
                END IF
            CASE "/favicon.ico"
                IF _FILEEXISTS("favicon.ico") THEN
                    ff = FREEFILE
                    OPEN "favicon.ico" FOR BINARY AS #ff
                    a$ = SPACE$(LOF(ff))
                    GET #ff, 1, a$
                    CLOSE ff
                    reply$ = "HTTP/1.0 200 OK" + crlf$
                    reply$ = reply$ + "Content-Length:" + STR$(LEN(a$)) + crlf$
                    reply$ = reply$ + "Content-Type: image/x-icon" + crlf$ + crlf$
                    reply$ = reply$ + a$
                ELSE
                    GOTO FourOhFour
                END IF
            CASE "/logs.html"
                textlog$ = ""
                loopnum = 0
                DO
                    loopnum = loopnum + 1
                    textlog$ = textlog$ + msg$(loopnum) + "<br>"
                LOOP UNTIL loopnum >= 10
                reply$ = "HTTP/1.0 200 OK" + crlf$ + crlf$
                reply$ = reply$ + "<html><head><link rel=" + CHR$(34) + "shortcut icon" + CHR$(34) + " type=" + CHR$(34) + "image/png" + CHR$(34) + " href=" + CHR$(34) + "/favicon.ico" + CHR$(34) + "/>"
                reply$ = reply$ + "<title>LittleChat Online Logs</title></head>"
                reply$ = reply$ + "<body><p>" + textlog$ + "</p><script>setTimeout(() => { location.reload(); }, 1000)</script></body></html>"
            CASE ELSE
                IF LEFT$(request$, 2) = "/?" AND request$ <> "/?" THEN
                    reply$ = "HTTP/1.0 200 OK" + crlf$ + crlf$
                    test$ = _TRIM$(RIGHT$(request$, LEN(request$) - 2))
                    fixSpace (test$)
                    test$ = _TRIM$(LEFT$(test$, 69))
                    PUT client, , test$
                    reply$ = reply$ + "<html><body><script>window.open('/', '_self');</script></body></html>"
                ELSE
                    unknownPage:
                    FourOhFour:
                    reply$ = "HTTP/1.0 404 Not found" + crlf$
                    reply$ = reply$ + "Content-Length: 103" + crlf$
                    reply$ = reply$ + "Content-Type: text/html" + crlf$ + crlf$
                    reply$ = reply$ + "<html><head><title>404 Not Found</title></head><body><p>This page does not exist.</p></body></html>" + crlf$ + crlf$
                END IF
        END SELECT
        PUT #c, , reply$
        CLOSE c
        c = 0
        x$ = ""
        request$ = ""
        reply$ = ""
    END IF
    new$ = ""
    GET client, , new$
    IF new$ <> "" THEN
        msg$(11) = new$
        loopnum = 12
        DO
            loopnum = loopnum - 1
            oldmsg$(loopnum - 1) = msg$(loopnum)
        LOOP UNTIL loopnum <= 1
        loopnum = 11
        DO
            loopnum = loopnum - 1
            msg$(loopnum) = oldmsg$(loopnum)
        LOOP UNTIL loopnum <= 1
    END IF
    _LIMIT 30
LOOP
CLOSE c
END

SUB fixSpace (code$)
    loopnum = 0
    complete = 0
    newcode$ = ""
    test$ = code$
    DO
        IF LEFT$(test$, 3) = "%20" THEN
            test$ = RIGHT$(test$, LEN(test$) - 3)
            newcode$ = newcode$ + " "
        ELSEIF LEFT$(test$, 3) = "%27" THEN
            test$ = RIGHT$(test$, LEN(test$) - 3)
            newcode$ = newcode$ + "'"
        ELSEIF LEFT$(test$, 3) = "%22" THEN
            test$ = RIGHT$(test$, LEN(test$) - 3)
            newcode$ = newcode$ + CHR$(34)
        ELSE
            newcode$ = newcode$ + LEFT$(test$, 1)
            test$ = RIGHT$(test$, LEN(test$) - 1)
        END IF
        IF test$ = "" THEN
            complete = 1
        END IF
    LOOP UNTIL complete = 1
    loopnum = 0
    complete = 0
    code$ = newcode$
END SUB

