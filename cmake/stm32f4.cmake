# ====================================================================
# AUTOMOTIVE EMBEDDED TOOLCHAIN CONFIGURATION
# ====================================================================

# ------------------------------------
# Define the Target Operating System
# ------------------------------------
#   - Generic : Bare-metal / AUTOSAR Classic (No OS layer, direct microcontroller code)
#   - Linux   : Automotive Grade Linux / Android Automotive (Infotainment, Navigation)
#   - QNX     : BlackBerry QNX Neutrino RTOS (Safety-certified ADAS, Digital Cockpits)
#   - VxWorks : Wind River VxWorks RTOS (Highly deterministic safety domain compute)

set(CMAKE_SYSTEM_NAME Generic)


# -----------------------------------
# Define the Target CPU Architecture
# -----------------------------------
# Options: 
#   - arm      : 32-bit safety microcontrollers (Cortex-M/R for Braking, Steering)
#   - aarch64  : 64-bit high-performance application chips (Cortex-A for ADAS, Clusters)
#   - x86_64   : Simulation targets or vehicle server edge environments

set(CMAKE_SYSTEM_PROCESSOR arm)


# --------------------------------------------------------------------
# Specify the Cross-Compilers (Adjust paths based on your installation)
# --------------------------------------------------------------------
# [architecture]-[vendor]-[os]-[abi]-[tool]
# 
# architecture - Target chip CPU layout:
#                - arm      : 32-bit safety microcontrollers (Braking, Steering, Airbags)
#                - aarch64  : 64-bit high-performance compute chips (ADAS, Infotainment)
#                - x86_64   : Host development PC or vehicle server simulation platforms
#
# vendor       - The compiler creator/distribution source:
#                - unknown  : Generic open-source GNU/Clang build (Common in free SDKs)
#                - poky     : Built by Yocto Project recipes (Automotive Grade Linux)
#                - fsl/nxp  : Provided directly by automotive silicon manufacturers
#                - (omitted): Completely skipped in standard bare-metal toolchains
#
# os           - The runtime operating system layer on the car hardware:
#                - none     : Bare-metal / AUTOSAR Classic (No filesystem, code runs directly on wires)
#                - nto      : BlackBerry QNX Neutrino RTOS (Safety-certified ADAS and instrument clusters)
#                - linux    : Automotive Grade Linux / Android Automotive (IVI, Navigation, Maps)
#
# abi          - The software platform version or calling convention rules:
#                - eabi     : Embedded ABI rules (Used for raw microcontroller memory layouts)
#                - eabihf   : Embedded ABI Hard-Float (Forces hardware acceleration for vehicle math/sensors)
#                - gnu      : Standard Linux library layer (glibc interface)
#                - qnx710   : Locked to BlackBerry QNX Software Development Platform version 7.1
#
# tool         - The specific executable being called to process the code:
#                - gcc      : The standard GNU C Compiler (Used for core micro firmware)
#                - g++      : The GNU C++ Compiler (Used for advanced object detection, C++ clusters)
#                - ld       : The linker (Binds object files into executable automotive images)
#                - objcopy  : Tool to convert binaries into flashable formats (.bin, .hex, or .srec/s19) 
#                - size     : Analyzes firmware memory usage (Ensures code fits into strict Flash/RAM limits)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_SIZE arm-none-eabi-size)


# --------------------------------------------------------------------
# !!! Crucial for Bare-Metal: Compiler Sanity Verification
# --------------------------------------------------------------------
# Because 'Generic' systems don't have a standard operating system loader,
# CMake will fail its initial compiler sanity test unless we tell it to 
# compile as a static library first.

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# --------------------------------------------------------------------
# Configure Target Hardware Flags
# --------------------------------------------------------------------
# -mcpu        : Selects the specific processor architecture core
# -mthumb      : Compresses instruction sizes to optimize flash memory usage
# -mfpu        : Enables the integrated hardware floating-point unit
# -mfloat-abi  : Directs the compiler to use hardware registers for float math

set(CPU_FLAGS  "-mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard")

# --------------------------------------------------------------------
# Initialize Compiler and Linker Flags
# --------------------------------------------------------------------
# CMAKE_C_FLAGS_INIT   : Sets baseline options for all C source files
# CMAKE_CXX_FLAGS_INIT : Sets baseline options for all C++ source files
# CMAKE_ASM_FLAGS_INIT : Sets baseline options for assembly source files
# CMAKE_EXE_LINKER     : Sets baseline linker options, optimizes for space, 
#                        and provides minimal stub implementations for standard C system calls

set(CMAKE_C_FLAGS_INIT "${CPU_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${CPU_FLAGS}")
set(CMAKE_ASM_FLAGS_INIT "${CPU_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${CPU_FLAGS} -specs=nano.specs -specs=nosys.specs")

# --------------------------------------------------------------------
# Search Target Environment Policy
# --------------------------------------------------------------------
# Force CMake to find programs on the host, but look for libraries,
# headers, and packages ONLY within the target toolchain directories.
# NEVER - Never look into target
# ONLY - Only look into target
# BOTH - Look into Host first, if unsuccessful look into target

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)