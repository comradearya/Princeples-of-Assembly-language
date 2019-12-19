STEG SEGMENT PARA STACK "STACK"
    DB 64 DUP ("STACK")
STEG ENDS

DSEG SEGMENT PARA PUBLIC "DATA"

Ttl db "First program", 0h
Msg db 'Hello World', 0h

DSEG ENDS

CSEG SEGMENT PARA PUBLIC "CODE"

    MAIN PROC NEAR
    ASSUME SS:STEG, DS:DSEG, CS:CSEG
push 0h
push offset Msg
push offset Ttl
push 0h
call MessageBoxA
push 0h
call ExitProcess

MAIN ENDP

extrn ExitProcess:PROC
extrn MessageBoxA:PROC

CSEG ENDS

END MAIN
