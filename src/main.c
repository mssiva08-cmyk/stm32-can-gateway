/* STM32 CAN Gateway — main entry point
 * Board: STM32F4 Discovery
 * Build: CMake + arm-none-eabi-gcc
 */

#include<stdint.h>

/* Test variables to verify .data and .bss initialization */
uint32_t can_baudrate_config = 500000; /* .data: Copied from Flash to SRAM at boot */
uint32_t can_error_count;              /* .bss: Zeroed in SRAM at boot */

int main(void)
{
    /* 1. Low-level hardware init (Clock, GPIO, CAN controller, etc.) */
    
    /* 2. Create FreeRTOS Tasks & Queues here */
    
    /* 3. Start FreeRTOS Scheduler (e.g., vTaskStartScheduler()) */

    while (1)
    {
        /* Main loop — FreeRTOS scheduler takes over, this is never reached */
    }
    return 0;
}