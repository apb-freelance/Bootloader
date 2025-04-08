# Archivos fuente
C_SRC      = bootloader.c
ASM_SRC    = print_char.asm
LD_SCRIPT  = link.ld

# Archivos intermedios y salida
C_OBJ      = bootloader.o
ASM_OBJ    = print_char.o
BIN        = boot.bin
IMG        = disk.img

# Compiladores y flags
CC         = gcc
ASM        = nasm
LD         = ld

CFLAGS     = -m32 -ffreestanding -nostdlib -fno-pic -c
LDFLAGS    = -m elf_i386 -T $(LD_SCRIPT)

# Compilación principal
all: $(IMG)

$(IMG): $(BIN)
	dd if=$(BIN) of=$(IMG) bs=512 count=1 conv=notrunc

$(BIN): $(C_OBJ) $(ASM_OBJ) $(LD_SCRIPT)
	$(LD) $(LDFLAGS) -o $@ $(C_OBJ) $(ASM_OBJ)

$(C_OBJ): $(C_SRC)
	$(CC) $(CFLAGS) -o $@ $<

$(ASM_OBJ): $(ASM_SRC)
	$(ASM) -f elf32 $< -o $@

# Lanzar con QEMU
run: $(IMG)
	qemu-system-i386 -drive format=raw,file=$(IMG)

# Limpiar
clean:
	rm -f $(BIN) $(IMG) *.o

.PHONY: all run clean
