STSEG SEGMENT PARA STACK "STACK"
DB 128 DUP ( 0 )
STSEG ENDS

dseg segment para "data"

    numb_request_message db 13,10, "Enter number(from -32768 to 32762);  $"
    numb_read_message db 7, 7 dup (0)
    error_messageX db 13,10, "Incorrect X. $"
    error_messageY db 13,10, "Incorrect Y. $"
    error_messageT db 13,10, "Incorrect T. $"
    error_func db 13,10, "Number out of range. $"
    
    ;entering db 10,13
    hello db 13,10, "The programm calculates the value of function(3 variant)$"
    integer db 13,10, "Integer = $"
    remainder db 13,10, "Remainder = $"
    
    your_num db 13,10, "Value number after '.'= $"
    x_mes db 13,10, "Enter x (integer from -32768 to 32767) -> $"
    second_mes db 13,10, "x^2+375$"
    first_mes db 13,10, "(1+x^2)/(1-x)$"
    third_mes db 13,10, "x^2/10$"
    sybbol_exit db 2, 2 dup (0)
    
    ask_message db 13,10, "Enter any key to try again or press ESC to exit program $"
    exit_message db 13,10, "EXITED $"

    varX dw 0
    varY dw 0
    varT dw 0
    numerator dw 0
    denumerator dw 0
    
    
    two dw 2
    five dw 5
    seven dw 7
    thirteen dw 13 
    
dseg ends

CSEG SEGMENT PARA PUBLIC "CODE"
MAIN PROC FAR
ASSUME CS: CSEG, DS: DSEG, SS: STSEG
; ?????? ??????????
    PUSH DS
    XOR AX, AX
    PUSH AX

    MOV AX, DSEG
    MOV DS, AX
    
    mov dx, offset hello
    mov ah,9                
    int 21h 
    
    jmp moduleInX
    
    errorableX:

        mov dx, offset error_messageX
        mov ah,9                
        int 21h 
        

    moduleInX:
        mov dx, offset x_mes
        mov ah,9
        int 21h

        call readAndConvert
        jc errorableX
        mov varX, ax
        ; jmp moduleInY
        
        ;   errorableY:
        ;
        ;   mov dx, offset error_messageY
        ; mov ah,9                
        ; int 21h 
        
        ;moduleInY:
        ;mov dx, offset y_mes
        ;mov ah,9
        ;int 21h

        ;call readAndConvert
        ;jc errorableY
        ;mov varY, ax
        ;jmp moduleInT
        ;errorableT:

        ; lea dx,error_messageT
        ; mov ah,9                
        ;int 21h 
        

        ; moduleInT:
        ; mov dx, offset t_mes
        ; mov ah,9
        ; int 21h

        ; call readAndConvert
        ; jc errorableT
        ; mov varT, ax
    
        jmp bridge
        bridgeIn:
    
    jmp moduleInX

    bridge:
    mov bx, varX
    cmp bx,-5 ; x<=-5
    jle first
    cmp bx,5 ; x<=5
    jle second
    jg third
    ;  mov ax, -5  
    
    
 
    first: ; <=-5
        mov dx, offset first_mes
        mov ah,9
        int 21h
        call firstProc
        jc continue
        jmp moduleOut
     second: ; <=5
        mov dx, offset second_mes
        mov ah,9
        int 21h
        call secondProc
        jc continue
        jmp moduleOut
    third:
        mov dx, offset third_mes
        mov ah,9
        int 21h
        call thirdProc
        jc continue
        jmp moduleOut
    
        
        
    moduleOut:
        push ax
        lea dx, your_num 
        mov ah,9            
        int 21h 
        pop ax
        call writeNumber
    continue:

      
      mov dx, offset ask_message
      mov ah, 9
      int 21h
      
      mov ah, 08h
      int 21h
      
      cmp al, 27
      jne bridgeIn
  
    main_exit:
      
      
      mov dx, offset exit_message
      mov ah, 9
      int 21h

ret
main endp

readAndConvert proc 
    push si
    push cx
    
    
    
    xor ax,ax
    mov ah,0Ah               
    lea dx,numb_read_message       
    int 21h                 
    mov al,[numb_read_message+1]   
    add dx,2                
    neg_number:
        test al,al              
        jz localError               
        mov bx, offset dx       
        mov bl,[bx]            
        cmp bl,'-'              
        jne stsdw_no_sign       
        inc dx                  
        dec al                  
    stsdw_no_sign:
        call number_module       
        jc localError
        cmp bl,'-'              
        jne stsdw_plus          
        cmp ax,32768            
        ja localError              
        neg ax                  
        jmp stsdw_ok           
    stsdw_plus:
        cmp ax,32767            
        ja localError               
    stsdw_ok:
        clc                     
    
    jmp return
    localError:
    
        stc
    
    return:
    pop cx
    pop si
ret
readAndConvert endp

number_module proc 
    push bx

 
    mov si, offset dx       
    mov di,10               
    
    xor cx,cx
    mov cl,al
    
    xor ax,ax               
    xor bx,bx               
 
    studw_lp:
        mov bl,[si]             
        inc si                  
        cmp bl,'0'              
        jb studw_error          
        cmp bl,'9'              
        ja studw_error          
        sub bl,'0'              
        mul di                  
        jc studw_error          
        add ax,bx               
        jc studw_error         
        loop studw_lp           
        jmp studw_exit          

    studw_error:
        xor ax,ax               
        stc                    

    studw_exit:
        pop bx
        ret
number_module endp

thirdProc proc
    xor si,si
    mov ax,varX
    mov bx,ax
    imul bx         ;ax = x^2  
    
    mov di, 10
    idiv di ; ax/di=ax 
    
    jmp print

    jmp thirdReturn
    thirdError:
        
        lea dx, error_func
        mov ah,9
        int 21h
        stc
            
    thirdReturn:
ret
thirdProc endp



firstProc proc

    mov ax, varX
    ;call writeNumber

    
    imul varX       ; x^2
    jo firstError
    add ax, 1; x^2+1

    
    xor cx,cx
    mov si, ax     ; si = x^2 +1
    ;
    xor ax,ax ; ax=0
    ;
    mov ax, varX    ;       ax=x
  ; neg ax ; ax=-x
  add ax, -1 ;         AX= x-1
  neg ax
    
    jo firstError

    mov di, ax           ; di = 1-x
    ;
    xor ax, ax ; ax=0
    ;
    mov ax, si ; ax=x^2+!
    idiv  di ; ax/di=ax
     print:

    xor bx,bx
    xor di,di
    mov bx,ax
    mov di,dx
    
    lea dx, integer
    mov ah,9
    int 21h
    
    mov ax,bx
    call writeNumber
    
    
    lea dx, remainder
    mov ah,9
    int 21h
    
    mov ax,di
    call writeNumber
    
    
    
    jmp firstReturn
    
    firstError:
        
        lea dx, error_func
        mov ah,9
        int 21h
        stc
            
        firstReturn:
    ret
    firstProc endp

secondProc proc

    xor si,si
    mov ax,varX
    mov bx,ax
    imul bx         ;ax = x^2
    jo secondError
    
    add ax, 375
    jo secondError



 
    
    
    jmp secondReturn
    secondError:
        
        lea dx, error_func
        mov ah,9
        int 21h
        stc
            
        secondReturn:
    jmp print
ret
secondProc endp




writeNumber proc 
    push bx
    push di
    push dx
    push ax
    
    
    mov bx,ax
    
        
    
    
    or bx, bx
    jns m1
    mov al, '-'
    int 29h
    neg bx
    m1:
    mov ax, bx
    xor cx, cx
    mov bx, 10
    m2:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz m2
    m3:
    pop ax
    int 29h
    loop m3
    pop ax
    pop dx
    pop di
    pop bx
    ret
writeNumber endp

cseg ends
end main