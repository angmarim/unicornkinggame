org 100h         ;use for .com files, since it sets the current adress to 100h and .com files start ar h10 adress
INCLUDE emu8086.inc  

.stack           ;reserve  quantity of memory for the stack, use for .exe since you need to create a stack of functions

.data
    ;utils section
    scrCleaner DB '$'

    ;msgs section
    msg_horned db "You got horned.$"
    msg_dodge db "Do not get horned!$"
    ;objects section
    char_main db "@$" 
    char_main_next db ?
    char_unicorn db "<$" 
    char_unicorn_next db ?
    ;variables section
    var_print_dodged_unicorns db "000$" ;hold string that represents the score
    var_dodged_unicorns dw 0            ;hold a number which means total score
 
    var_must_quit db 9                  ;flag when player quit
    
    var_pos_char_main dw 0              ;hold position of main character
    var_pos_char_unicorn dw 0           ;hold position of unicorn character
 
    ;configuration section
    startX db 39    ;start position of main char
    startY db 24    ;start position of main char    
             
    move_right db 4
    move_left db 6
    
    jmp start      

    
.code
start:
    ;limpa buffer para print
    MOV ax, SEG scrCleaner
    MOV ds,ax  

    ;Configuration section
        ;set char position
        MOV DH, startY      ;set y coordinate value for main char
        MOV DL, startX      ;set x coord val to main char
        GOTOXY DL, DH       ;place cursor at this position
        ;print char in position
        PUTC char_main      ;print main char in GOTOXY position
        ;resets
        XOR AL, AL          ;AL = 0 *see logic classes to understand*
     
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
            ;move keyboard buffer to ax     ;#
            MOV AH, 1                       ;#
            INT 16h                         ;#
            CMP AH, 4                     ;#
            JE  movLeft                     ;#
            CMP AH, 6                     ;#
            JE  movLeft                     ;#
                returnAfterMove:            ;#
            JMP returnFromMoveChar          ;#
;#############################################     

;MOVE CHAR SECTION                         
;#####################################################
        movLeft:                                    ;#
            ;set new position                       ;#
            INC startX                              ;#
            MOV DL, startX                          ;#
            GOTOXY DL, DH                           ;#
            call CLEAR_SCREEN                            ;#
            ;print char again in new position       ;#
            PUTC char_main                          ;#
            XOR AL, AL          ;clean register     ;#
            JMP returnAfterMove ;go back to loop    ;#
                                                    ;#
        movRight:                                   ;#
            ;set new position                       ;#
            INC startX                              ;#
            MOV DL, startX                          ;#
            GOTOXY DL, DH                           ;#
            call CLEAR_SCREEN                            ;#
            ;print char in new position             ;#
            PUTC AL, AL                             ;#
            XOR AL, AL                              ;#
            JMP returnAfterMove ;go back to loop    ;#
;#####################################################

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