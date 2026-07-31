/*
 * ==================================================================================
 * File:        bootup_stm32f407xx.s
 * Description: Minimal assembly boot code for STM32F407xx. 
 *              Sets up directives, global symbols, and the vector table.
 * ==================================================================================
 */

.syntax unified     /* use modern unified assembly syntax rules for instructions */
.cpu cortex-m4      /* targets Cortex-M4 processor core */
.fpu fpv4-sp-d16    /* Enables hardware Floating Point Unit (single-precision) */
.thumb              /* Output Thumb instructions, as required by Cortex-M core */


.global g_pfnVectors    /* The interrupt vector table (the list of handlers for CPU events) */
.global Reset_Handler   /* The reset handler (the CPU's first entry point on boot) */
.global Default_Handler /* The default handler (for unimplemented interrupts) */

/* Vector table */

.section .isr_vector,"a",%progbits /* Create allocatable section for vector table */

g_pfnVectors:
  .word _estack                           /*  1. Initial Stack Pointer (top of SRAM) */
  .word Reset_Handler                     /*  2. Reset Handler (entry point on power-up) */
  .word NMI_Handler                       /*  3. Non-Maskable Interrupt (NMI) */
  .word HardFault_Handler                 /*  4. All classes of fault (Hard Fault) */
  .word MemManage_Handler                 /*  5. Memory Management Fault */
  .word BusFault_Handler                  /*  6. Bus Fault */
  .word UsageFault_Handler                /*  7. Usage Fault */
  .word 0                                 /*  8. Reserved */
  .word 0                                 /*  9. Reserved */
  .word 0                                 /* 10. Reserved */
  .word 0                                 /* 11. Reserved */
  .word SVC_Handler                       /* 12. System Service Call via SVC instruction */
  .word DebugMon_Handler                  /* 13. Debug Monitor */
  .word 0                                 /* 14. Reserved */
  .word PendSV_Handler                    /* 15. Pendable request for system service */
  .word SysTick_Handler                   /* 16. System Tick Timer */


/* Reset handler */

.section .text.Reset_Handler, "ax", %progbits   /* Create allocatable, executable section for Reset Handler */
.type Reset_Handler, %function                  /* Marks symbol as a Thumb function */

Reset_Handler:
bl c_startup

Infinite_Loop_Main:
  b Infinite_Loop_Main

.size Reset_Handler, .-Reset_Handler


/* Default handler for unimplemented interrupts */

.section .text.Default_Handler,"ax",%progbits   /* Create allocatable, executable section for Default_Handler */
.type Default_Handler, %function                /* Marks symbol as a Thumb function */

Default_Handler:
Infinite_Loop:
  b Infinite_Loop

.size Default_Handler, .-Default_Handler


/* Weak aliases — can be overridden in application code */
  
.weak NMI_Handler
.thumb_set NMI_Handler,Default_Handler

.weak HardFault_Handler
.thumb_set HardFault_Handler,Default_Handler

.weak MemManage_Handler
.thumb_set MemManage_Handler,Default_Handler

.weak BusFault_Handler
.thumb_set BusFault_Handler,Default_Handler

.weak UsageFault_Handler
.thumb_set UsageFault_Handler,Default_Handler

.weak SVC_Handler
.thumb_set SVC_Handler,Default_Handler

.weak DebugMon_Handler
.thumb_set DebugMon_Handler,Default_Handler

.weak PendSV_Handler
.thumb_set PendSV_Handler,Default_Handler

.weak SysTick_Handler
.thumb_set SysTick_Handler,Default_Handler

