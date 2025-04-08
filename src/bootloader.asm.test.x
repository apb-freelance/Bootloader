org 0x7C00

start:
    mov ah, 0x0E
    mov al, 'X'
    int 10h
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
