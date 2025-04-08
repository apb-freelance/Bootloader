# 🧠 Guía del Bootloader en Ensamblador (Modo Real)

Una referencia clara y directa para entender y construir un bootloader desde cero, usando NASM y el BIOS en modo real.

---

## 🧩 Conceptos clave

### ✨ ¿Qué es un bootloader?
- Es el **primer programa** que se ejecuta al encender el PC.
- El BIOS carga los **primeros 512 bytes** del disco en la dirección `0x7C00` de la RAM.
- El bootloader debe **terminar con la firma `0xAA55`** para que el BIOS lo reconozca como válido.

### ⚙️ Requisitos
- Tamaño exacto de **512 bytes** (sector estándar).
- Modo real (segmentado, 16 bits).
- Control total del sistema: no hay sistema operativo, ni protecciones.

---

## 🧠 Explicación detallada del código

```nasm
org 0x7C00        ; BIOS carga el bootloader aquí
```
- `org` es una directiva que le dice al ensamblador que el código se **cargará en memoria** en la dirección `0x7C00`.
- Esto es importante porque el BIOS, al arrancar desde el disco, **siempre carga el primer sector (512 bytes) del disco en esa dirección**.

```nasm
start:
    ; Configurar modo de video 03h (texto)
    mov ah, 0
    mov al, 3
    int 10h
```
- Establece el modo de video 03h (modo texto, 80x25 caracteres, 16 colores).
- Se hace para garantizar que el entorno visual esté limpio y predecible.

```nasm
    ; Mostrar un mensaje
    mov si, mensaje
    call print_string
```
- Se carga en `SI` la dirección del mensaje.
- Se llama a una subrutina `print_string` que imprimirá carácter por carácter.

```nasm
    jmp $          ; Bucle infinito (espera)
```
- Salto a la misma dirección (el símbolo `$` es "la posición actual").
- Esto evita que el bootloader caiga en código basura o se ejecute más allá de lo que debe.

```nasm
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
```
- `lodsb` carga el siguiente byte apuntado por `SI` en `AL`.
- `or al, al` comprueba si es cero (fin de cadena).
- Si no lo es, usa `int 10h` con función 0x0E (teletipo) para imprimirlo.

```nasm
mensaje db "Bootloader cargado. Preparando dragones...", 0
```
- Cadena de texto terminada en `0` (null).
- Se imprimirá carácter a carácter.

```nasm
times 510 - ($ - $$) db 0
```
- Esto rellena con ceros hasta que el archivo alcance **exactamente 510 bytes**.
- `$` es la posición actual, `$$` es el inicio del archivo.
- El BIOS **espera exactamente 512 bytes**: ni más, ni menos.

```nasm
dw 0xAA55         ; Firma del MBR
```
- Los **últimos 2 bytes** deben contener esta firma mágica (`0xAA55`).
- Si no está presente, **el BIOS no intentará ejecutar el sector como código**.

---

## 🔄 Flujo de ejecución

1. BIOS carga los 512 bytes del MBR en `0x7C00`.
2. Establece el puntero de ejecución en esa dirección y empieza a ejecutar.
3. El bootloader configura video, imprime mensaje y se queda esperando.

---

## ⚖️ ¿Por qué `0x7C00`?
- Es una **convención de IBM BIOS original**, que reservaba esa dirección para cargar el MBR.
- Está dentro del primer segmento del sistema (segmento 0), accesible desde modo real.

## 🧱 ¿Por qué 512 bytes?
- Un **sector estándar** de disco tiene 512 bytes.
- El BIOS lee un sector desde el disco al arrancar: **solo eso**.
- Por tanto, el bootloader **debe caber entero en esos 512 bytes**.

## 🧩 ¿Por qué rellenar con ceros?
- Si tu código ocupa menos de 510 bytes, debes **rellenar hasta llegar a esa cantidad**.
- Los últimos dos bytes **están reservados para la firma**.
- Si no rellenas, podrías dejar basura, y el BIOS podría ignorar el sector.

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

