; print_char.asm - Función llamada desde C para imprimir un carácter usando int 10h
; Compilar con: nasm -f elf32 print_char.asm -o print_char.o

global print_char

section .text
print_char:
    push ax
    mov ah, 0x0E      ; Función: teletipo (int 10h)
    mov al, [esp + 4] ; Obtener argumento (char c) desde la pila
    int 0x10
    pop ax
    ret
