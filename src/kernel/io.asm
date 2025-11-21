[bits 32]

section .text

global inb
inb:
    push ebp
    mov ebp, esp

    xor eax, eax; 将 eax 置为 0
    mov edx, [ebp+ 8]; port
    in al, dx; 将 dx 端口的数据读入 al

    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟

    leave
    ret

global outb
outb:
    push ebp
    mov ebp, esp

    mov edx, [ebp+ 8]; port
    mov eax, [ebp+ 12]; value
    out dx, al; 将 al 的数据写入 dx 端口

    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟

    leave
    ret

global inw
inw:
    push ebp
    mov ebp, esp

    xor eax, eax; 将 eax 置为 0
    mov edx, [ebp+ 8]; port
    in ax, dx; 将 dx 端口的数据读入 ax

    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟

    leave
    ret

global outw
outw:
    push ebp
    mov ebp, esp

    mov edx, [ebp+ 8]; port
    mov eax, [ebp+ 12]; value
    out dx, ax; 将 ax 的数据写入 dx 端口

    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟
    jmp $ + 2; 一点点延迟

    leave
    ret
