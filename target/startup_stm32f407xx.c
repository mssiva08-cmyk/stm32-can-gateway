/*
 * ==================================================================================
 * File:        startup.c
 * Description: Bare-metal C startup file for STM32F407xx.
 *              Copies .data section from Flash to SRAM, zeroes out .bss section,
 *              and transfers control to main().
 * ==================================================================================
 */

#include <stdint.h>

/* 
 * ==================================================================================
 * Linker Script Symbols
 *
 * Note: These are defined in link.ld. They don't hold data themselves;
 * their addresses represent physical memory boundaries.
 * 
 * Declared as uint32_t so pointer math operates in 32-bit (4-byte) word steps.
 * ==================================================================================
 */

 
extern uint32_t _sidata; /* Start of .data section in Flash (Source) */
extern uint32_t _sdata;  /* Start of .data section in SRAM  (Destination) */
extern uint32_t _edata;  /* End of .data section in SRAM */

extern uint32_t _sbss;   /* Start of .bss section in SRAM */
extern uint32_t _ebss;   /* End of .bss section in SRAM */

/* Prototype for application entry point */
extern int main(void);
 
/*
 * ==================================================================================
 * Function:    c_startup
 * Description: Called by Reset_Handler in bootup_stm32f407xx.s
 * ==================================================================================
 */
void c_startup(void) {
    /* 1. Calculate number of 32-bit words to copy for .data */
    uint32_t data_size = (uint32_t *)&_edata - (uint32_t *)&_sdata;
    uint32_t *pSource  = (uint32_t *)&_sidata;
    uint32_t *pDest    = (uint32_t *)&_sdata;

    /* Copy .data from Flash to SRAM */
    for (uint32_t i = 0; i < data_size; i++) {
        *pDest++ = *pSource++;
    }

    /* 2. Calculate number of 32-bit words to zero-fill for .bss */
    uint32_t bss_size = (uint32_t *)&_ebss - (uint32_t *)&_sbss;
    pDest             = (uint32_t *)&_sbss;

    /* Zero-fill .bss section in SRAM */
    for (uint32_t i = 0; i < bss_size; i++) {
        *pDest++ = 0;
    }

    /* 3. Call application entry point */
    main();

    /* Safety loop in case main() ever returns */
    while (1) {
        /* Trap CPU */
    }
}