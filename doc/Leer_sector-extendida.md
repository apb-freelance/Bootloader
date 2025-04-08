# 📚 Leer un sector extra desde el disco (Explicación detallada)

Este documento explica paso a paso el segundo módulo del bootloader, centrado en leer un sector adicional desde el disco utilizando la BIOS en modo real.

---

## 🔄 Flujo general

1. El BIOS ya ha cargado el bootloader en `0x7C00`.
2. Este código activa el modo texto por limpieza visual.
3. Muestra un mensaje: "Leyendo sector 2 del disco..."
4. Realiza la llamada a `int 13h` para leer el sector 2.
5. Si todo va bien, muestra mensaje de éxito.
6. Si algo falla, muestra mensaje de error.

---

## 🔗 Código comentado

```nasm
org 0x7C00
```
El código sigue cargándose desde la misma dirección usada por el BIOS.

```nasm
mov ah, 0
mov al, 3
int 10h
```
Configura el modo de video 03h: texto 80x25, 16 colores. Esto limpia la pantalla.

```nasm
mov si, mensaje_lectura
call print_string
```
Muestra el mensaje de que se va a leer el sector.

```nasm
mov ah, 02h        ; función BIOS: leer sectores
mov al, 01h        ; leer 1 sector
mov ch, 0          ; cilindro 0
mov cl, 2          ; sector 2 (el primero después del MBR)
mov dh, 0          ; cabeza 0
mov dl, 80h        ; unidad: primer disco duro
mov bx, buffer     ; offset donde guardar el sector
mov es, 0x0000     ; segmento donde guardar el sector
int 13h            ; llamada al BIOS
```
Esto le dice al BIOS que lea el **sector 2** desde el disco (CHS: 0/0/2), y que lo guarde en la dirección **0000:buffer**.

```nasm
jc lectura_fallo
```
Si ocurre un error, el BIOS activa el bit de *carry*. En ese caso, saltamos a mostrar el mensaje de error.

```nasm
mov si, mensaje_ok
call print_string
jmp $
```
Muestra mensaje de éxito y entra en bucle infinito.

```nasm
lectura_fallo:
mov si, mensaje_error
call print_string
jmp $
```
Mensaje de error si falla la lectura.

---

## 🤔 Por qué el sector 2 y no el 1

- El **sector 1 (MBR)** ya fue cargado por el BIOS (contiene el bootloader).
- El siguiente sector disponible para carga de datos es el **sector 2**.
- Si tuvieras más datos (código, tabla de particiones extendida, stage 2, etc), puedes colocarlos ahí.

---

## 🔄 Sobre la dirección de carga (buffer)

```nasm
buffer: times 512 db 0
```
Esto define una zona de memoria de 512 bytes **dentro del propio bootloader** donde se guardará el sector leído.
- Usamos el segmento `0x0000` y offset `buffer`, que al estar justo después del código no interfiere.
- Podrías también usar `0x0600` o `0x0500` si prefieres cargar fuera del bootloader.

---

## ⚡ Comprobación de errores

- La BIOS devuelve el estado de la operación en el **carry flag**.
- `jc` significa "jump if carry" → salta solo si hubo error.
- Esto te permite controlar el flujo en base al éxito o fallo de la lectura.

---

## ⚡ Curiosidades

- `int 13h` sigue funcionando en modo real y es fundamental para cargadores personalizados.
- Puedes leer más de un sector a la vez cambiando `al`.
- El sistema CHS (cilindro/cabeza/sector) tiene límites, pero es suficiente para los primeros pasos.

---

## 🚀 Paso siguiente sugerido
- Usar lo que has leído del disco para **mostrarlo en pantalla**.
- Leer más de un sector y concatenar datos.
- O saltar a la dirección leída y ejecutar lo que haya (cargar stage 2 o mini-kernel).

Smith, acabas de pasar de "bootloader" a "gestión activa de disco". Bienvenido al club de los que leen directamente desde sectores. 🪩

