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

mov si, booting
call print

mov edi, 0x1000; 目标地址
mov ecx, 2; 起始扇区号
mov bl, 4; 扇区数量

call read_disk

cmp word [0x1000], 0x55aa
jnz error
jmp 0:0x1002

jmp $; 无限循环

; 读取磁盘
; 输入：edi - 数据地址，cl - 起始扇区号，bl - 扇区数量
read_disk:
    ; 设置读写的扇区数量
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    ; 设置起始扇区号的 0 ~ 7 位
    inc dx  ; 0x1f3
    mov al, cl
    out dx, al

    ; 设置起始扇区号的 8 ~ 15 位
    inc dx  ; 0x1f4
    shr ecx, 8
    mov al, cl
    out dx, al

    ; 设置起始扇区号的 16 ~ 23 位
    inc dx  ; 0x1f5
    shr ecx, 8
    mov al, cl
    out dx, al

    inc dx  ; 0x1f6
    shr ecx, 8
    and cl, 0b1111; 将高 4 位置为 0
    mov al, 0b1110_0000; 主盘，LBA 模式
    or al, cl
    out dx, al

    inc dx  ; 0x1f7
    mov al, 0x20; 读硬盘
    out dx, al

    xor ecx, ecx; 将 ecx 置为 0
    mov cl, bl; 得到要读写的扇区数量

    .read:
        push cx; 保存 cx
        call .waits; 等待磁盘准备好
        call .reads; 读取一个扇区
        pop cx; 恢复 cx
        loop .read
    
    ret

    .waits:
        mov dx, 0x1f7
        .check:
            in al, dx
            jmp $ + 2; 直接跳转到下一行 = nop
            jmp $ + 2; 一点点延迟
            jmp $ + 2
            and al, 0b1000_1000; 保留第 3 和第 7 位
            cmp al, 0b0000_1000
            jnz .check
        ret
    
    .reads:
        mov dx, 0x1f0
        mov cx, 256; 每个扇区 512 字节，每个字 2 字节，共 256 个字
        .readw:
            in ax, dx
            jmp $ + 2; 直接跳转到下一行 = nop
            jmp $ + 2; 一点点延迟
            jmp $ + 2
            mov [edi], ax
            add edi, 2
            loop .readw
        ret

; 打印字符串
; 输入：si - 字符串地址
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

error:
    mov si, .msg
    call print
.halt:
    hlt; 停机
    jmp .halt; 如果被唤醒，则继续停机
 
    .msg db "Booting Error!!!", 10, 13, 0 ; \n\r\0

; 将中间未使用的空间填充为 0
times 510-($-$$) db 0

; 主引导扇区的最后两个字节必须是 0x55 0xaa
db 0x55, 0xaa; 等价于 dw 0xaa55