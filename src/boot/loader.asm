[org 0x1000]

dw 0x55aa; 魔数

mov si, loading
call print

; xchg bx, bx; bochs 魔数断点

detect_memory:
    xor ebx, ebx; 将 ebx 置为 0

    ; es:di - ARDS 结构体缓冲区
    mov ax, 0
    mov es, ax
    mov edi, ards_buffer

    mov edx, 0x534d4150; 固定签名
.next:
    mov eax, 0xe820; 功能号
    mov ecx, 20; ARDS 结构体大小
    int 0x15

    jc error; 如果 CF 被置位，表示出错
    add di, cx; 指向下一个 ARDS 结构体
    inc word [ards_count]; ARDS 结构体数量加一

    cmp ebx, 0; 判断是否还有更多的 ARDS 结构体
    jnz .next; 如果有，继续循环

    mov si, detecting
    call print

    jmp prepare_protected_mode

prepare_protected_mode:
    ; xchg bx, bx; bochs 魔数断点

    cli; 关中断

    ; 打开 A20 线
    in al, 0x92
    or al, 0b10
    out 0x92, al

    lgdt [gdt_ptr]; 加载 GDT

    ; 开启保护模式
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp dword code_selector:protect_mode; 用远跳转刷新流水线，来让 CPU 真正切换到保护模式

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
    db "Loading LeOS...", 10, 13, 0; \n\r\0
detecting:
    db "Detecting Memory Success...", 10, 13, 0; \n\r\0

error:
    mov si, .msg
    call print
.halt:
    hlt; 停机
    jmp .halt; 如果被唤醒，则继续停机
 
    .msg db "Loading Error!!!", 10, 13, 0 ; \n\r\0

[bits 32]
protect_mode:
    ; xchg bx, bx; bochs 魔数断点

    ; 初始化段寄存器
    mov ax, data_selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x10000; 设置栈顶

    mov edi, 0x10000; 目标地址
    mov ecx, 10; 起始扇区号
    mov bl, 200; 扇区数量
    
    call read_disk

    jmp dword code_selector:0x10000; 跳转到内核

    ud2; 表示出错

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
        loop .reads
    
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

code_selector equ (1 << 3)
data_selector equ (2 << 3)

memory_base equ 0; 基地址
memory_limit equ ((1024 * 1024 * 1024 * 4) / (1024 * 4)) - 1; 段界限（4GB / 4KB - 1）

gdt_ptr:
    dw (gdt_end - gdt_base - 1)
    dd gdt_base
gdt_base:
    dd 0, 0; NULL 描述符
gdt_code:
    dw memory_limit & 0xffff; 段界限 0 ~ 15 位
    dw memory_base & 0xffff; 基地址 0 ~ 15 位
    db (memory_base >> 16) & 0xff; 基地址 16 ~ 23 位
    db 0b_1_00_1_1_0_1_0; 存在 - dpl 0 - S _ 代码 - 非依从 - 可读  - 没有被访问过
    db 0b_1_1_0_0_0000 | (memory_limit >> 16) & 0xf; 4K - 32 位 - 不是 64 位 - A - 段界限 16 ~ 19 位
    db (memory_base >> 24) & 0xff; 基地址 24 ~ 31 位
gdt_data:
    dw memory_limit & 0xffff; 段界限 0 ~ 15 位
    dw memory_base & 0xffff; 基地址 0 ~ 15 位
    db (memory_base >> 16) & 0xff; 基地址 16 ~ 23 位
    db 0b_1_00_1_0_0_1_0; 存在 - dpl 0 - S _ 数据 - 向上 - 可写  - 没有被访问过
    db 0b_1_1_0_0_0000 | (memory_limit >> 16) & 0xf; 4K - 32 位 - 不是 64 位 - A - 段界限 16 ~ 19 位
    db (memory_base >> 24) & 0xff; 基地址 24 ~ 31 位
gdt_end:

ards_count:
    dw 0
ards_buffer: