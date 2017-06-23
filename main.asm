org 100h         ;use for .com files, since it sets the current adress to 100h and .com files start ar h10 adress
INCLUDE emu8086.inc  

.stack           ;reserve  quantity of memory for the stack, use for .exe since you need to create a stack of functions

.data
    ;utils section
    scrCleaner DB '$'
    eraseChar db ' $'
    ;msgs section
    msg_horned db "You got horned.$"
    msg_dodge db "Do not get horned!$"
msg_game_start  db "==== How To Play ====", 0dh,0ah
            db "Avoid the unicorns using 'a' and 'd'", 0dh,0ah,0ah   
            db "Press Esc to exit.", 0dh,0ah
            db "====================", 0dh,0ah, 0ah
            db "Press any key to start!$"
    ;objects section
    char_main db "@$" 
    char_unicorn db "<$" 
    ;variables section
    var_print_dodged_unicorns db "000$" ;hold string that represents the score
    var_dodged_unicorns dw 0            ;hold a number which means total score
 
    var_must_quit db 9                  ;flag when player quit

    ;configuration section
    startX db 39    ;start position of main char
    startY db 24    ;start position of main char    
    jmp start      

    
.code
start:

;WAIT PLAYER START
;################################
;print msg_game_start          ;#
mov dx, offset msg             ;#
mov ah, 9                      ;#
int 21h                        ;#
; wait key press to start      ;#
mov ah, 00h                    ;#
int 16h                        ;#
;################################
 
;GAME START CONFIG
;########################################################################
    ;limpa buffer para print                                           ;#
    call CLEAR_SCREEN                                                  ;#
    MOV ax, SEG scrCleaner                                             ;#
    MOV ds,ax                                                          ;#
                                                                       ;#
    ;Configuration section                                             ;#
        ;set char position                                             ;#
        MOV DH, startY      ;set y coordinate value for main char      ;#
        MOV DL, startX      ;set x coord val to main char              ;#
        GOTOXY DL, DH       ;place cursor at this position             ;#
        ;print char in position                                        ;#
        PUTC char_main      ;print main char in GOTOXY position        ;#
        ;resets                                                        ;#
        XOR AL, AL          ;AL = 0 *see logic classes to understand*  ;#
;########################################################################
     
     ;FUNCTIONS
;MAIN LOGIC SECTION
;###################################################################################
        waitKeyPress:                                                             ;#
            ;check if keystroke true/false                                        ;#
            MOV AH, 1                                                             ;#
            INT 16H         ;interruption to check if keyboard buffer have a value;#
            ;if keystroke flag true goto                                          ;#
            JNZ moveChar    ;if flag from interruption 1, go to move char function;#
                returnFromMoveChar:                                               ;#
            ;goto functions that move unicorns                                    ;#
            JMP moveUnicorns                                                      ;#
                returnMoveUnicorns:                                               ;#
            ;keep checking all above forever other then....                       ;#
            ;...missing if horned die                                             ;#
            JMP waitKeyPress                                                      ;#
;###################################################################################      

;LOGIC FOR MOVING CHAR OR UNICORNS OR BOTH SECTION
;#############################################
        moveChar:                           ;#
            CMP AL,'a'                      ;#
            JE  movLeft                     ;#
            CMP AL, 'd'                     ;#
            JE  movRight                    ;#
            returnAfterMove:                ;#
            JMP returnFromMoveChar          ;#
;#############################################     

;MOVE CHAR SECTION                         
;#################################################################
        movLeft:                                                ;#
            ;erase old char position                            ;#
            GOTOXY DL, DH                                       ;#
            PUTC eraseChar                                      ;#
            ;check if off board                                 ;#
            CMP startX, 2      ;if off board                    ;#
            JLE ifLeftOffBoard;ignore all under                 ;#
            ;set new position                                   ;#
            DEC startX                                          ;#
            MOV DL, startX                                      ;#
            ;if offboard start from here                        ;#
            ifLeftOffBoard:                                     ;#
            GOTOXY DL, DH ;get X position                       ;#
            ;print char again in new position if not off board  ;#
            PUTC char_main                          ;#          ;#
            XOR AL, AL          ;clean register     ;#          ;#
            MOV AH, 08h ;clear keyboard buffer so it doesnt     ;#
            INT 21H     ;keep moving and change direction       ;#
            JMP returnAfterMove ;go back to loop    ;#          ;#
                                                    ;#          ;#
        movRight:                                               ;#
            ;erase old char position                            ;#
            GOTOXY DL, DH                                       ;#
            PUTC eraseChar                                      ;#
            ;check if off board                                 ;#
            CMP startX, 78      ;if off board                   ;#
            JGE ifRightOffBoard;ignore all under                ;#
            ;set new position                                   ;#
            INC startX                                          ;#
            MOV DL, startX                                      ;#
            ifRightOffBoard:                                    ;#
            GOTOXY DL, DH                                       ;#
            ;print char in new position                         ;#
            PUTC char_main                                      ;#
            XOR AL, AL                                          ;#
            MOV AH, 08h   ;clear keyboard buffer so it doesnt   ;#
            INT 21H       ;keep moving and change direction     ;#
            JMP returnAfterMove ;go back to loop                ;#
;#################################################################

;MOVE UNICORNS SECTION  
;#############################################
        moveUnicorns:                       ;#
            JMP returnMoveUnicorns          ;#
;#############################################        
DEFINE_CLEAR_SCREEN 
DEFINE_SCAN_NUM
    ;stop process
    MOV AX, 4C00h ; prepare to interrupt process
    INT 21h ; interrup process
end start