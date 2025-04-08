# 🧠 Guía visual: Cómo funciona el arranque por sectores

Esta guía explica paso a paso qué ocurre al arrancar desde un disco, qué código se ejecuta, dónde se carga y por qué usamos direcciones como `0x0600` en memoria.

---

## 🧱 Estructura típica del disco de arranque

```plaintext
┌────────────┐
│ Sector 0   │  -> MBR / Bootloader (stage 1)
│ 512 bytes  │  -> BIOS lo carga automáticamente en 0x7C00
└────────────┘
┌────────────┐
│ Sector 1   │  -> (opcional, puede estar vacío)
└────────────┘
┌────────────┐
│ Sector 2+  │  -> Stage 2 (leer_sector.asm)
│ N * 512    │  -> Cargado manualmente con int 13h
└────────────┘
```

---

## 🧭 Flujo de ejecución

1. **El BIOS carga el sector 0 en la dirección 0x7C00**
2. El bootloader (MBR) se ejecuta desde `org 0x7C00`
3. Este ejecuta `int 13h` para leer sectores adicionales desde disco (por ejemplo, el sector 2)
4. El bootloader carga el stage 2 en otra dirección de memoria (por ejemplo, `0x0000:0600` = físico `0x0600`)
5. Luego hace un `jmp 0x0000:0x0600` para transferir el control al stage 2

---

## 🧠 Por qué usamos `es:bx = 0000:0600`

La BIOS lee sectores en memoria **segmentada**, y necesita dos cosas:
- **Segmento**: cargado en `ES`
- **Offset**: cargado en `BX`

Entonces:
```nasm
mov ax, 0x0000
mov es, ax
mov bx, 0x0600
int 13h   ; Lee un sector a partir de ES:BX => 0000:0600
```

Esto coloca el contenido del sector leído exactamente en la dirección física `0x0000:0600`.

💡 Luego haces:
```nasm
jmp 0x0000:0x0600
```
Para ejecutar el código que acabas de cargar.

---

## 🧾 Diferencias entre stage 1 y stage 2

| Característica        | Stage 1 (boot.asm)        | Stage 2 (leer_sector.asm)     |
|------------------------|----------------------------|--------------------------------|
| Tamaño máximo          | 512 bytes                  | Múltiplos de 512              |
| Posición de carga      | 0x7C00 (por BIOS)          | Donde tú decidas (ej: 0x0600) |
| Firma requerida        | `0xAA55` en el byte 511-512| Ninguna                        |
| Cargado por...         | BIOS                       | Tu bootloader (int 13h)       |
| Funciones típicas      | Leer disco, saltar a stage 2 | Mostrar texto, cargar SO, etc |

---

## 🧰 Glosario rápido

- **MBR**: Master Boot Record. Primer sector de un disco.
- **org**: Directiva de ensamblador que indica la dirección donde se ejecutará el código.
- **ES:BX**: Dirección segmentada usada por el BIOS para cargar datos en memoria.
- **0x7C00**: Dirección fija donde el BIOS carga el sector 0.
- **0x0600**: Dirección arbitraria donde el bootloader carga el stage 2.

---

## ✅ Resumen final

```plaintext
BIOS --> Carga sector 0 en 0x7C00 --> Ejecuta boot.asm -->
Lee sector 2 en 0x0600 con int 13h --> Salta a 0x0600 --> Ejecuta stage 2
```

Tú decides cuántos sectores cargar, dónde ponerlos en RAM y qué hacen a partir de ahí. ¡Ahí empieza tu sistema!

