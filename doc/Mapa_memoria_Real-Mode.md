# 🧠 Mapa de memoria en modo real (x86)

Este documento resume las regiones de memoria en el modo real (8086/BIOS) y qué puede o no puede colocarse en cada una. Muy útil para el diseño de bootloaders, cargadores de sistema operativo o entornos bare metal.

---

## 🧱 Direcciones clave (modo real)

```plaintext
Dirección        Tamaño        Uso / Riesgo
────────────────────────────────────────────────────────
0000:0000     0x0000 - 0x03FF   🛑 Tabla de interrupciones (IVT)
0000:0400     0x0400 - 0x04FF   ⚠️  BIOS Data Area (BDA)
0000:0500     0x0500 - 0x07FF   ✅ Generalmente libre (con cuidado)
0000:0800     0x0800 - 0x09FF   ✅ Libre (buffer de lectura)
0000:0A00     0x0A00 - 0x0BFF   ✅ Libre, a menudo usado por DOS
0000:0C00     0x0C00 - 0x7BFF   ✅ Libre, pero cuidado con RAM usada por BIOS
0000:7C00     0x7C00 - 0x7DFF   📌 MBR cargado por el BIOS
0000:7E00     0x7E00 - 0x9FFF   ✅ Generalmente seguro
0000:A000     0xA000 - 0xBFFF   ⚠️  Video RAM (modo gráfico/texto)
0000:C000     0xC000 - 0xFFFF   ⚠️  ROM BIOS y extensiones
```

---

## 📌 Zonas típicas para tus programas

| Uso propuesto            | Dirección sugerida |
|--------------------------|---------------------|
| Cargar stage 2           | `0x0600`, `0x0800`, `0x8000` |
| Buffers temporales       | `0x0500` a `0x07FF` |
| Stack (pila)             | `0x9FFF` hacia abajo |
| Cargar kernel / binarios | `0x1000`, `0x8000`, `0x9000` |

---

## ⚠️ Zonas a evitar

| Dirección        | Motivo                       |
|------------------|------------------------------|
| `0x0000 - 0x03FF`| 🛑 Tabla de interrupciones (IVT) |
| `0x0400 - 0x04FF`| ⚠️  BIOS Data Area (BDA)       |
| `0xA000 - 0xBFFF`| ⚠️  RAM de video               |
| `0xC000 - 0xFFFF`| ⚠️  ROM BIOS                   |

---

## ✅ Consejo práctico

Si no sabes dónde cargar algo:

- Usa `0x0600` para stage2 si tu MBR está en `0x7C00`
- Usa `0x8000` para códigos mayores (modo protegido, kernel)
- Nunca escribas en `0x0000` directamente: arruinarás la IVT

---

## 🧭 Dirección física vs segmentada

En modo real, una dirección física se calcula así:

```plaintext
segmento:offset = (segmento << 4) + offset
```

Por ejemplo:
```plaintext
ES = 0x0000
BX = 0x0600
=> Dirección física: 0x0000 + 0x0600 = 0x0600
```

Esto es lo que usa BIOS para leer sectores con `int 13h`.

---

Este mapa es tu referencia cuando construyes cualquier programa en bajo nivel, desde bootloaders hasta sistemas operativos bare metal.

