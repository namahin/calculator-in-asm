.MODEL SMALL
.STACK 100H
.DATA
    menu db 10,13, "Choose (+ - * / %), C/c=Clear, X/x=Exit: $"   
    
    firstNum db 10,13, "Enter first number (0-9): $"
    secondNum db 10,13, "Enter second number (0-9): $" 
    
    exprMsg db 10,13, "Expression: $"
    
    resultMsg db " = $"
    resultMsg2 db " = -$"            
    
    errorDiv0 db 10,13,10, "Error! Division by zero.$"
    invalidInput db 10,13,10, "Invalid key! Please try again with right key.$"
    mathError db 10,13,10, "Math Error! Try with Small Numbers!$"
    newline db 10,13, "$"

    choice db ?
    num1 db ?
    num2 db ?
    result db ?
    op db ?

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

start_loop:
    ; show menu
    lea dx, menu
    mov ah, 09h
    int 21h

    ; read operation key
    mov ah, 01h
    int 21h
    mov al, al
    mov choice, al

    ; exit handling
    cmp al, 'X'
    je terminator
    cmp al, 'x'
    je terminator

    ; clear handling 
    cmp al, 'C'
    je clear_screen
    cmp al, 'c'
    je clear_screen

    ; operator keys
    cmp al, '+'
    je store_op
    cmp al, '-'
    je store_op
    cmp al, '*'
    je store_op
    cmp al, '/'
    je store_op
    cmp al, '%'
    je store_op

    ; invalid keys handling 
    lea dx, invalidInput
    mov ah, 09h
    int 21h
    jmp start_loop

store_op:
    mov op, al
    
    ; input first number
    lea dx, firstNum
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, 48
    mov num1, al

    ; input second number
    lea dx, secondNum
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, 48
    mov num2, al

    ; matching operation
    cmp op, '+'
    je addition
    cmp op, '-'
    je subtraction
    cmp op, '*'
    je multiplication
    cmp op, '/'
    je division
    cmp op, '%'
    je modulus

    jmp start_loop

; addition
addition:
    mov al, num1
    add al, num2
    mov result, al
    jmp show_expression

; subtraction
subtraction:
    mov al, num1
    mov bl, num2

    cmp al, bl
    jg subtract_normally

    ; else do num2 - num1
    mov al, bl
    sub al, num1
    mov result, al
    jmp show_expression2

subtract_normally:
    sub al, bl
    mov result, al
    jmp show_expression

; multiplication
multiplication:
    mov al, num1
    mov bl, num2
    mul bl
    mov result, al
    jmp show_expression

; division
division:
    cmp num2, 0
    je div_by_zero
    xor ax, ax
    mov al, num1
    mov bl, num2
    div bl
    mov result, al
    jmp show_expression

; modulus
modulus:
    cmp num2, 0
    je div_by_zero
    xor ax, ax
    mov al, num1
    mov bl, num2
    div bl
    mov result, ah
    jmp show_expression

div_by_zero:
    lea dx, errorDiv0
    mov ah, 09h
    int 21h
    jmp start_loop 
    
 
; expressions handling 
show_expression:   
    cmp result, 9
    jg result_too_large
    
    lea dx, exprMsg
    mov ah, 09h
    int 21h

    mov dl, num1
    add dl, 48
    mov ah, 02h
    int 21h

    mov dl, op
    mov ah, 02h
    int 21h

    mov dl, num2
    add dl, 48
    mov ah, 02h
    int 21h

    lea dx, resultMsg
    mov ah, 09h
    int 21h

    mov dl, result
    add dl, 48
    mov ah, 02h
    int 21h
    jmp start_loop

result_too_large:
    lea dx, mathError
    mov ah, 09h
    int 21h
    jmp start_loop

show_expression2:
    lea dx, exprMsg
    mov ah, 09h
    int 21h

    mov dl, num1
    add dl, 48
    mov ah, 02h
    int 21h

    mov dl, op
    mov ah, 02h
    int 21h

    mov dl, num2
    add dl, 48
    mov ah, 02h
    int 21h

    lea dx, resultMsg2
    mov ah, 09h
    int 21h

    mov dl, result
    add dl, 48
    mov ah, 02h
    int 21h
    jmp start_loop

; clear code
clear_screen:
    xor dx,dx
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp start_loop

; exit code
terminator:
    mov ah, 4Ch
    int 21h
    
MAIN ENDP
END MAIN
RET