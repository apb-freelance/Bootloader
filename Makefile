SRC_DIR  = src
OBJ_DIR  = obj
DEP_DIR  = dep

ASM      = nasm
ASFLAGS  = -f bin

BOOT_BIN   = $(OBJ_DIR)/boot.bin
STAGE2_BIN = $(OBJ_DIR)/stage2.bin
IMG        = disk.img

all: $(IMG)

$(IMG): boot stage2
	dd if=$(BOOT_BIN) of=$(IMG) bs=512 count=1 conv=notrunc
	dd if=$(STAGE2_BIN) of=$(IMG) bs=512 seek=1 count=2 conv=notrunc

boot:
	@mkdir -p $(OBJ_DIR) $(DEP_DIR)
	$(ASM) $(ASFLAGS) -MD -MF $(DEP_DIR)/boot.d -o $(BOOT_BIN) $(SRC_DIR)/boot.asm

stage2:
	@mkdir -p $(OBJ_DIR) $(DEP_DIR)
	$(ASM) $(ASFLAGS) -MD -MF $(DEP_DIR)/payload.d -o $(STAGE2_BIN) $(SRC_DIR)/payload.asm

run: $(IMG)
	qemu-system-i386 -drive format=raw,file=$(IMG)

clean:
	rm -rf $(OBJ_DIR) $(DEP_DIR) $(IMG)

-include $(DEP_DIR)/boot.d $(DEP_DIR)/leer_sector.d
