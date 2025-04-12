SRC_DIR  = src
OBJ_DIR  = obj
DEP_DIR  = dep

MKF=/usr/bin/make -C

#ASM      = nasm
#ASFLAGS  = -f bin

BOOT_BIN   = boot/boot.bin
STAGE2_BIN = stage2/stage2.bin
IMG        = disk.img

all: $(IMG)

$(IMG):
	$(MKF) boot
	dd if=$(BOOT_BIN) of=$(IMG) bs=512 count=1 conv=notrunc
	#dd if=$(STAGE2_BIN) of=$(IMG) bs=512 seek=1 count=2 conv=notrunc

run: $(IMG)
	qemu-system-i386 -drive format=raw,file=$(IMG)

clean:
	$(MKF) boot/ clean
	rm -rf $(OBJ_DIR) $(DEP_DIR) $(IMG)

-include $(DEP_DIR)/boot.d $(DEP_DIR)/leer_sector.d
