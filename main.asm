model small
org 100h         ;use for .com files, since it sets the current adress to 100h and .com files start ar h10 adress
;jmp start
.stack           ;reserve  quantity of memory for the stack, use for .exe since you need to create a stack of functions

.data
    ;utils section
    scrCleaner DB '$'
    ;msgs section
    msg_horned db "You got horned.$"
    msg_dodge db "Do not get horned!$"
    ;objects section
    char_main db "@$"
    char_unicorn db "<$"
    ;variables section
    var_print_dodged_unicorns db "000$" ;hold string that represents the score
    var_dodged_unicorns dw 0            ;hold a number which means total score
    
    var_must_quit db 0                  ;flag when player quit
    
    var_pos_char_main dw 0              ;hold position of main character
    var_pos_char_unicorn dw 0           ;hold position of unicorn character
    
    X dw 0
    Y dw 0
    B dw 0
    ;-----
    jmp start      

    tam equ 0
    cursor dw  tam dup(0) 

    acima      equ     48h
    abaixo    equ     50h  
    parado    equ     52h

    direcao db  parado 
    prd1 db "************* $"
    prd2 db "|$"

    vertical equ $- prd1
    horizontal equ $- prd2

    msg     db "==== Como Jogar ====", 0dh,0ah
    db "Use as setas p/ cima e p/ baixo para controlar o cursor", 0dh,0ah,0ah   
    db "Aperte Esc para sair", 0dh,0ah
    db "====================", 0dh,0ah, 0ah
    db "Aperte qualquer tecla para comecar!$"
    ;-----

    
.code
start:
    ;limpa buffer para print
    MOV ax, SEG scrCleaner
    MOV ds,ax 
    ;keyboard config
    MOV ax, 0305h
    XOR bx, bx
    INT 16h
    ;enter graphic mode, 300x200 8bit color
    MOV ax, 13h 
    INT 10h

; print da mensagem
mov dx, offset msg
mov ah, 9
int 21h   

; aguardando tecla para iniciar
mov ah, 00h
int 16h

; escondendo o cursor de texto  
mov ah, 1
mov ch, 2bh
mov cl, 0bh
int 10h    


;parede1 prd1 
;parede2 prd2

loop_jogo:

; desenhar campo


; colocando cursor no inicio da tela
mov al, 0
mov ah, 05h
int 10h

mov dx, cursor

mov ah, 02h 
int 10h

mov al, '@'
mov ah, 09h
mov bl, 0eh
mov cx, 1
int 10h



    
    ;stop process
    MOV AX, 4C00h ; prepare to interrupt process
    INT 21h ; interrup process    
end start