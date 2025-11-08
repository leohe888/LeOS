[org 0x7c00]

; 设置显示模式为文本模式
mov ax, 3
int 0x10

; 初始化段寄存器
mov ax, 0
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

; 0xb8000 是文本模式下的显存起始地址
mov ax, 0xb800
mov es, ax
mov byte [0], 'H'

; 死循环
jmp $

; 将中间未使用的空间填充为 0
times 510-($-$$) db 0

; 主引导扇区的最后两个字节必须是 0x55 0xaa
db 0x55, 0xaa   ; 等价于 dw 0xaa55