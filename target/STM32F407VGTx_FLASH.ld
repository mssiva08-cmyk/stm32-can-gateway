/* Linker script for STM32F407VGTx
 * Flash: 1MB  starting at 0x08000000
 * RAM:   128KB starting at 0x20000000
 * CCMRAM: 64KB starting at 0x10000000
 */

ENTRY(Reset_Handler)

_estack = ORIGIN(RAM) + LENGTH(RAM); /* end of "RAM" Ram type memory */

_Min_Heap_Size = 0x400; /* required amount of heap - 1KB */
_Min_Stack_Size = 0x800; /* required amount of stack - 2KB */

MEMORY
{
  FLASH (rx)   : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM   (xrw)  : ORIGIN = 0x20000000, LENGTH = 128K
  CCMRAM (xrw) : ORIGIN = 0x10000000, LENGTH = 64K
}

SECTIONS
{
  /* Vector table and code go into FLASH */
  .isr_vector :
  {
    . = ALIGN(512);
    KEEP(*(.isr_vector)) 
  } >FLASH

  .text :
  {
    . = ALIGN(8);
    *(.text)
    *(.text*)
    *(.rodata)
    *(.rodata*)
    KEEP(*(.init))
    KEEP(*(.fini))

  } >FLASH

  /* Initialized data — stored in FLASH, copied to RAM at startup */
  _sidata = LOADADDR(.data);
  .data :
  {
    . = ALIGN(8);
    _sdata = .;
    *(.data)
    *(.data*)
    . = ALIGN(8);
    _edata = .;
  } >RAM AT> FLASH



  /* Uninitialized data — zeroed at startup */
  .bss :
  {
    . = ALIGN(8);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(8);
    _ebss = .;
  } >RAM

  /* Stack at top of RAM */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE(end = .);
    PROVIDE(_end = .);
    . = . + _Min_Heap_Size;  /* 1KB heap */
    . = . + _Min_Stack_Size;  /* 2KB stack */
  } >RAM
}