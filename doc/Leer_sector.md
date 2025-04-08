# 📦 Leer un sector extra desde el disco (Resumen)

Este módulo complementa el bootloader cargado en `0x7C00` y utiliza la interrupción BIOS `int 13h` para leer el **sector 2** del disco (justo después del MBR).

---

## 🧩 ¿Qué hace este código?

1. Configura el modo de video en texto (modo 03h).
2. Muestra un mensaje indicando que se va a leer un sector.
3. Usa `int 13h` (función 02h) para leer el sector 2 del disco.
4. Guarda el contenido en una zona de memoria (`buffer`).
5. Si la lectura es exitosa, muestra un mensaje de éxito.
6. Si falla, muestra un mensaje de error.

---

## 💾 Detalles importantes

- El sector 2 es el **primer sector utilizable después del MBR**.
- El contenido se guarda en `0x0000:buffer`, justo dentro del mismo bootloader.
- Se usa `int 13h` con los parámetros adecuados (CHS: cilindro 0, cabeza 0, sector 2).
- El salto `jc` detecta si la operación de lectura falló (carry flag).

---

## ✅ Resultado

- Si todo va bien, verás un mensaje confirmando la lectura.
- Si falla (por ejemplo, al montar un disco sin ese sector), verás un mensaje de error.

---

Este módulo prepara el camino para cargar un segundo stage, leer una tabla de particiones o incluso un mini-kernel desde disco. 💻

