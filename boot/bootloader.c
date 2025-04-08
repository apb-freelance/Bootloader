/* bootloader.c - Bootloader mínimo en C con rutina de BIOS en ASM */

__attribute__((section(".start")))

extern void print_char(char c);  // Definida en ASM

void boot_main(void) {
    const char *msg1 = "Hola desde BIOS! camino de Stage2...\r\n";

    // Imprimir usando rutina externa ASM (int 10h)
    for (int i = 0; msg1[i] != '\0'; i++) {
        print_char(msg1[i]);
    }
    while (1);
}

// Espacio de relleno hasta byte 510
__attribute__((section(".fill")))
char filler[510 - 2 - 158] = {0};
//const unsigned char padding[510] = {0};

// Firma obligatoria al final del sector
__attribute__((section(".sig")))
unsigned short boot_signature = 0xAA55;
