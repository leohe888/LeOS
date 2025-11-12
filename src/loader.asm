[org 0x1000]

dw 0x55aa   ; 魔术

mov si, loading
call print

xchg bx, bx ; bochs 魔术断点

detect_memory:
    xor ebx, ebx    ; 将 ebx 置为 0

    ; es:di - ARDS 结构体缓冲区
    mov ax, 0
    mov es, ax
    mov edi, ards_buffer

    mov edx, 0x534d4150 ; 固定签名
.next:
    mov eax, 0xe820 ; 功能号
    mov ecx, 20 ; ARDS 结构体大小
    int 0x15

    jc error ; 如果 CF 被置位，表示出错
    add di, cx  ; 指向下一个 ARDS 结构体
    inc word [ards_count] ; ARDS 结构体数量加一

    cmp ebx, 0 ; 判断是否还有更多的 ARDS 结构体
    jnz .next ; 如果有，继续循环

    mov si, detecting
    call print

    xchg bx, bx ; bochs 魔术断点

    mov cx, [ards_count]    ; ARDS 结构体数量
    mov si, 0   ; ARDS 结构体索引
.show:
    mov eax, [ards_buffer + si]
    mov ebx, [ards_buffer + si + 8]
    mov edx, [ards_buffer + si + 16]
    add si, 20
    xchg bx, bx ; bochs 魔术断点
    loop .show

; 死循环
jmp $

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

loading:
    db "Loading LeOS...", 10, 13, 0 ; \n\r\0
detecting:
    db "Detecting Memory Success...", 10, 13, 0 ; \n\r\0

error:
    mov si, .msg
    call print
.halt:
    hlt ; 停机
    jmp .halt ; 如果被唤醒，则继续停机
 
    .msg db "Loading Error!!!", 10, 13, 0 ; \n\r\0

ards_count:
    dw 0
ards_buffer: