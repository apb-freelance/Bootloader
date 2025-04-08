# 🧰 Herramientas para analizar binarios e imágenes de disco

Una guía rápida para explorar, desensamblar y visualizar el contenido de archivos `.bin`, `.img`, y sectores individuales como los usados en bootloaders y sistemas de bajo nivel.

---

## 🔎 1. `strings` – Buscar cadenas de texto

```bash
strings archivo.bin
```
- Muestra texto ASCII legible embebido en binarios.
- Muy útil para localizar mensajes dentro de un `boot.bin` o `disk.img`.

---

## 🧠 2. `ndisasm` – Desensamblador plano de NASM

```bash
ndisasm -o 0x7C00 disk.img
```
- `-o 0x7C00` especifica la dirección de carga en memoria.
- Ideal para ver código binario plano como `boot.bin`.

Ver sector 2, por ejemplo:
```bash
dd if=disk.img bs=512 skip=1 count=1 of=sector2.bin
ndisasm -o 0x0000 sector2.bin
```

---

## 🔬 3. `hexdump` – Visualizar en HEX + ASCII

```bash
hexdump -C archivo.bin
```
- Muestra el contenido hexadecimal junto al equivalente ASCII.
- Perfecto para localizar texto, instrucciones o patrones dentro del binario.

---

## 🧬 4. `radare2` – Entorno de análisis interactivo

```bash
r2 -b 16 -m 0x7C00 disk.img
```
- `-b 16` → 16 bits (modo real).
- `-m 0x7C00` → dirección base simulada.
- Permite navegación, desensamblado, análisis y depuración.

Comandos útiles dentro de `r2`:
```r2
aaa           ; analiza todo el binario
pdf @ 0x7C00  ; ver código desensamblado
izz           ; buscar cadenas de texto
px @ 0x7C00   ; dump en hex desde esa dirección
```

---

## 🖼️ 5. `Cutter` – GUI para Radare2

- Interfaz gráfica sobre `r2`.
- Muestra flujos de ejecución, cadenas, análisis de funciones.
- Recomendado para análisis visual y navegación fácil.
- Sitio oficial: [https://cutter.re](https://cutter.re)

---

## ⚡ Bonus: extraer sectores con `dd`

```bash
dd if=disk.img bs=512 skip=1 count=1 of=sector2.bin
```
- `skip=1` → salta el primer sector (MBR).
- `count=1` → solo copia un sector (512 bytes).
- Útil para analizar el contenido del sector cargado por `int 13h`.

---

## ✅ Recomendaciones

| Objetivo                      | Herramienta recomendada |
|-------------------------------|--------------------------|
| Ver texto embebido            | `strings`                |
| Desensamblar boot.bin         | `ndisasm`                |
| Ver binario en HEX/ASCII      | `hexdump`                |
| Explorar a fondo con contexto | `radare2`, `Cutter`      |

---

Estas herramientas te permiten examinar cualquier `.img` o `.bin` con el mismo detalle con el que el BIOS los ve: sector por sector, byte por byte. 🔍💾

