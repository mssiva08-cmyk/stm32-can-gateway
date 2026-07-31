# ==============================================================================
# Root CMake Build Configuration for stm32_can_gateway Firmware
# Target: Bare-Metal ARM Cortex-M4 (STM32F4) — Pure C & Assembly Pipeline
# ==============================================================================

# ---------------------------------------------
# Minimum CMake Version & Policy Enforcement
# ---------------------------------------------
# Guards the build system against older CMake installations to prevent syntax errors. 
# It ensures modern target-based features are supported and freezes CMake's internal 
# behaviors/policies to guarantee identical builds across different machine environments

cmake_minimum_required(VERSION 3.15)

# ----------------------------
# Toolchain File Registration
# ----------------------------
# Explicitly defines the path to our target-specific hardware configuration file.
# Crucial: This MUST be set before the project() call so CMake uses the cross-compiler
# during the initial compiler verification phase

#set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/cmake/stm32f4.cmake)

# --------------------------------------------------------
# Project Declaration & Toolchain Language Initialization
# --------------------------------------------------------
# Defines the project name and explicitly restricts the build system to C and 
# Assembly compilers. This prevents CMake from looking for or linking C++ 
# standard libraries (libstdc++), keeping the binary footprint ultra-lean for bare-metal

project(stm32_can_gateway C ASM)

# ----------------------------------
# C Language Standard Specification
# ----------------------------------
# Enforces the ISO C11 standard for compilation. Enabling C_STANDARD_REQUIRED 
# ensures the build fails early if the compiler lacks C11 support

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# ------------------------------------------
# Default Build Type Fallback Configuration
# ------------------------------------------
# If no build configuration (Debug, Release, etc.) is explicitly passed via 
# the command line, default the workspace to 'Debug'. This ensures compiler optimization 
# is lowered (-O0) and debugging symbols (-g) are preserved for development.
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

# ----------------------------------------------------
# Global Compiler Warning and Size Optimization Flags
# ----------------------------------------------------
# -Wall -Wextra: Activates strict static analysis warnings to catch programming bugs early.
# -fdata-sections -ffunction-sections: Places each variable and function into its own 
#  isolated memory section. This enables the linker to prune unused code later.
# -fno-exceptions: Disables C++ style exception handling overhead to save critical Flash space.
add_compile_options(
    -Wall
    -Wextra
    -fdata-sections
    -ffunction-sections
    # -fno-exceptions  # C++ only — uncomment if C++ files are added
)

# -------------------------------------
# Core Application Source Registration
# -------------------------------------
# Explicitly lists the source compilation units required to build our gateway application

set(SOURCES
  src/main.c
  target/bootup_stm32f407xx.s
  target/startup_stm32f407xx.c
)

# -----------------------------
# Output Executable Definition
# ------------------------------
# Links our registered sources into a target ELF binary file using the project name

add_executable(${PROJECT_NAME} ${SOURCES})

set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".elf")

#add_library()

#target_link_libraries()

#target_include_directories()

# ---------------------------------------------
# Linker Level Pruning and Map File Generation
# ---------------------------------------------
# -Wl,--gc-sections: Instructs the linker to perform "Garbage Collection," completely 
#  sweeping and deleting any unused functions or variables isolated by the compiler flags.
# -Wl,-Map=...: Outputs a comprehensive linker memory map file detailing exactly 
#  where every function and variable lives in physical Flash and RAM.

target_link_options(${PROJECT_NAME} PRIVATE
    -T${CMAKE_SOURCE_DIR}/target/STM32F407VGTx_FLASH.ld
    -Wl,--gc-sections
    -Wl,-Map=${PROJECT_NAME}.map
#--specs=nano.specs
#    --specs=nosys.specs
) 

# ----------------------------------------------
# Post-Build Image Generation and Size Analysis
# ----------------------------------------------
# Automated pipeline executed immediately upon successful target generation:
# 1. Invokes objcopy to translate the bloated ELF container into a raw binary flash image.
# 2. Invokes size to parse memory segments and output absolute Flash/RAM byte consumption.

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}> $<TARGET_FILE_DIR:${PROJECT_NAME}>/${PROJECT_NAME}.bin
  COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}>
  COMMENT "Generating binary and printing size"
)



