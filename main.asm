model small
org 100h        ;use for .com files, since it sets the current adress to 100h and .com files start ar h10 adress
.stack 100h     ;reserve  quantity of memory for the stack, use for .exe since you need to create a stack of functions

.data

.code
start:

end start