[org 0x7c00]

; 将显示模式设置为文本模式
mov ax, 3
int 0x10

; 初始化段寄存器
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

xchg bx, bx ; bochs 魔数断点，需要修改 bochs 配置文件：magic_break: enabled=1

mov si, booting
call print

; 死循环
jmp $

print:
    mov ah, 0x0e
.next:
    mov al, [si]
    cmp al, 0
    jz .done
    int 0x10
    inc si
    jmp .next
.done:
    ret

booting:
    db "Booting LeOS...", 10, 13, 0 ; \n\r\0

; 将中间未使用的空间填充为 0
times 510-($-$$) db 0

; 主引导扇区的最后两个字节必须是 0x55 0xaa
db 0x55, 0xaa   ; 等价于 dw 0xaa55