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
.code
start:
    ;limpa buffer para print
    MOV ax, SEG scrCleaner
    MOV ds,ax 
    ;enter graphic mode, 300x200 8bit color
    mov ax, 13h 
    int 10h

    
    
    ;stop process
    MOV AX, 4C00h ; prepare to interrupt process
    INT 21h ; interrup process    
end start