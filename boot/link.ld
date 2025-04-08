OUTPUT_FORMAT ("binary")
ENTRY (boot_main)

SECTIONS {
  . = 0x7C00;
  .text : { KEEP(*(.start)) KEEP(*(.text)) }
  .fill : { KEEP(*(.fill)) }
  .sig  : { KEEP(*(.sig)) }
  /DISCARD/ : {
	  *(.eh_frame) *(.comment) *(.note) *(.debug)
  }
}
