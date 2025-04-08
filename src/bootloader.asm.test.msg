org 0x7C00

start:
    ; Establece modo texto
    mov ah, 0
    mov al, 3
    int 10h

    ; Muestra mensaje desde el propio MBR
    mov si, mensaje
    call print_string
    jmp $

mensaje db "MBR OK y funcionando.", 0

print_string:
.next:
    lodsb
    or al, al
    jz .fin
    mov ah, 0x0E
    int 10h
    jmp .next
.fin:
    ret

times 510 - ($ - $$) db 0
dw 0xAA55
