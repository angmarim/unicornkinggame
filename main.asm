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

    
    name "unicorngame"

org 100h   

jmp start  

scrCleaner db '$'    

tam equ 1
cursor dw  tam dup(0) 

acima      equ     48h
abaixo    equ     50h  
parado    equ     52h

direcao db  abaixo    
espera dw 0
prd1 db "************* $"
prd2 db "|$"

vertical equ $- prd1
horizontal equ $- prd2

msg 	db "==== Como Jogar ====", 0dh,0ah
	db "Avoid the unicorns using arrow keys", 0dh,0ah,0ah	
	db "Press esc to exit.", 0dh,0ah
	db "====================", 0dh,0ah, 0ah
	db "Press any key to start!$"


;----codigo-----    

start:

; print da mensagem
mov dx, offset msg
mov ah, 9
int 21h   

; aguardando tecla para iniciar
mov ah, 00h
int 16h

; escondendo o cursor de texto
mov ax, SEG scrCleaner
mov ds, ax  
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

mov al, 02h   ;;CURSOR
mov ah, 09h
mov bl, 0eh
mov cx, 1
int 10h





cmp al, 1bh ;tecla esc
je parar              

call move_cursor   

mov ah,02h 
int 10h    

mov al, ' '
mov ah, 09h
mov bl,0eh
mov cx, 1
int 10h



;;;;;;funcoes;;;;; 


verificar_tecla:
mov ah, 01h
int 16h
jz sem_tecla   


sem_tecla:
mov ah, 00h
int 1ah
cmp dx, espera
jb verificar_tecla
add dx, 4
mov espera, dx





;;;;;loop eterno;;;;;;;
jmp loop_jogo

  
macro setpos x,y
    mov ah,02h
    mov  dh,x
    mov dl, y
    int 10h
endm

macro parede1 horizontal 
    setpos 1,1
    mov ah, 09h
    lea dx, horizontal
    int 21h
    
    setpos 11,1
    mov ah, 09h
    lea dx, horizontal
    int 21h
endm

macro parede2 vertical
    mov cx,11
    for setpos cl,00h
    mov ah, 09h
    lea dx, vertical
    int 21h
    
    setpos cl, 0eh
    mov ah, 09h
    lea dx, vertical
    int 21h
    loop for
endm
         
parar:
mov ah, 1
mov ch, 0bh
mov cl, 0bh
int 10h    

move_cursor proc near

mov ax, 40h
mov es, ax  

mov di, tam
mov cx, tam-1

cmp direcao, acima
je pcima

cmp direcao, abaixo
je pbaixo    

jmp para_cursor


pcima:
mov al, b.cursor
dec al
mov b.cursor, al
cmp al, -1
jne para_cursor
mov al, es:[84h] ; linha num -1
mov b.cursor, al   ; volta p baixo
jmp para_cursor

pbaixo:
mov al, b.cursor
inc al
mov b.cursor, al
cmp al, es:[84h] ; linha num +1
jbe para_cursor
mov b.cursor, 0       ; volta p topo 
jmp para_cursor

para_cursor:
ret

move_cursor endp



    
    ;stop process
    MOV AX, 4C00h ; prepare to interrupt process
    INT 21h ; interrup process    
end start