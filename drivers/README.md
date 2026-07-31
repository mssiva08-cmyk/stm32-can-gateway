# Drivers & Middleware Directory

This directory contains low-level hardware definitions, third-party middleware, and peripheral drivers for the **STM32F407** microcontroller.

To keep the repository clean, light, and deterministic, all third-party code has been pruned to target **only** our exact hardware configuration (ARM Cortex-M4F + GCC).

---

## 1. CMSIS Hardware Definitions (`drivers/STM32F4/`)

* **CMSIS Core (`CMSIS_CORE`):** 
  Contains ARM Cortex-M4 CPU definitions and GCC compiler abstractions (`core_cm4.h`, `cmsis_gcc.h`). Unused architectures and toolchains (Keil, IAR) were removed.
* **CMSIS Device (`CMSIS_F4`):** 
  Contains ST Microcontroller register maps (`stm32f407xx.h`). Headers for other chip variants (`stm32f401`, `stm32f429`, etc.) were removed to prevent header bloat.

---

## 2. FreeRTOS Kernel (`drivers/FreeRTOS/kernel/`)

* **Portable Layer (`GCC/ARM_CM4F`):** 
  Retained only `port.c` and `portmacro.h` for ARM Cortex-M4 with Hardware Floating Point Unit support.
  
* **Memory Management (`heap_4.c`):** 
  Selected **`heap_4.c`** for dynamic task and queue allocations because it automatically merges adjacent free memory blocks (coalescence) to prevent heap fragmentation. Unused options (`heap_1`–`heap_3`, `heap_5`) were removed.

---

## 3. Custom Peripheral Drivers (`drivers/`)

* **GPIO Driver (`drivers/gpio/`):** Register-level driver for pin configuration, bit manipulation, and alternate functions.