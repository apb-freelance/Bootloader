# 🧠 Guía del Bootloader en Ensamblador (Modo Real)

Una referencia clara y directa para entender y construir un bootloader desde cero, usando NASM y el BIOS en modo real.

---

## 🧩 Conceptos clave

### ✨ Qué es un bootloader
- Es el **primer programa** que se ejecuta al encender el PC.
- El BIOS carga los **primeros 512 bytes** del disco en la dirección `0x7C00` de la RAM.
- El bootloader debe **terminar con la firma `0xAA55`** para que el BIOS lo reconozca como válido.

### ⚙ Requisitos
- Tamaño exacto de **512 bytes**.
- Debe estar en modo real (segmentado, 16 bits).
- Control total del sistema: no hay sistema operativo, ni protecciones.

---

## ⚡ Estructura básica de un bootloader

```nasm
org 0x7C00        ; BIOS carga el bootloader aquí

start:
    ; Configurar modo de video 03h (texto)
    mov ah, 0
    mov al, 3
    int 10h

    ; Mostrar un mensaje
    mov si, mensaje
    call print_string

    jmp $          ; Bucle infinito (espera)

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

mensaje db "Bootloader cargado. Preparando dragones...", 0

; Rellenar hasta 510 bytes
times 510 - ($ - $$) db 0

dw 0xAA55         ; Firma del MBR
```

---

## 🔄 Flujo de ejecución

1. BIOS carga los 512 bytes en `0x7C00`.
2. Salta automáticamente a esa dirección.
3. El bootloader:
   - Cambia a modo texto (por claridad).
   - Imprime un mensaje por pantalla.
   - Se queda en bucle (espera o ejecuta lo que venga después).

---

## ⚖️ Firma del MBR
Al final del bootloader:
```nasm
dw 0xAA55
```
Esto debe estar exactamente en el byte **511-512**.
Si no está presente, el BIOS ignora el sector y no lo ejecuta.

---

## 🔌 Cosas importantes para el siguiente paso
- Podemos usar **`int 13h`** para leer sectores adicionales del disco.
- Podemos cambiar a **modo gráfico (13h)** para mostrar píxeles.
- Todo esto se hace sin sistema operativo, controlando el hardware directamente.

---

## 🚀 Próximos pasos posibles
- Leer un segundo sector (cargar stage 2).
- Leer el MBR completo y mostrar la tabla de particiones.
- Cambiar a modo 13h y pintar en VGA.
- Cargar un "mini-kernel" en memoria y saltar a él.

---

Smith... estás entrando en la parte divertida del sistema. ¡Sólo tú, la RAM y el caos controlado! 🚀💪

