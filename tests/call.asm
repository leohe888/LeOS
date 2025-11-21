[bits 32]

extern exit

global main
main:
    pusha
    popa
    call exit
