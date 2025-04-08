; leer_sector.asm - Segundo módulo: leer un sector adicional del disco con int 13h

org 0x00600

mensaje_lectura db "Leyendo sector 2 del disco...", 0
mensaje_ok      db 13, 10, "Sector cargado con exito.", 0
mensaje_error   db 13, 10, "Error al leer el sector.", 0

buffer: times 512 db 0

start:
    ; Configura modo texto por limpieza visual
    mov ah, 0
    mov al, 3
    int 10h

    ; Mensaje antes de leer
    mov si, mensaje_lectura
    call print_string

    ; Configura parámetros para int 13h (leer 1 sector)
    mov ah, 02h        ; función: leer sectores
    mov al, 01h        ; número de sectores: 1
    mov ch, 0          ; cilindro: 0
    mov cl, 2          ; sector: 2 (el primero que no es MBR)
    mov dh, 0          ; cabeza: 0
    mov dl, 80h        ; unidad: primer disco duro
    mov bx, buffer     ; offset destino
    mov ax, 0x0000     ; se hace asi por limitaciones del set
    mov es, ax         ; segmento destino
    int 13h

    jc lectura_fallo   ; si falla, salta a error

    ; Mostrar mensaje de éxito
    mov si, mensaje_ok
    call print_string

    jmp $

lectura_fallo:
    mov si, mensaje_error
    call print_string
    jmp $

print_string:
.next:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 10h
    jmp .next
.done:
    ret

times 1024 - ($ - $$) db 0

;dw 0xAA55
