cmake_minimum_required(VERSION 3.22)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/cmake/stm32f4.cmake)

project(stm32_can_gateway C ASM)

set(CMAKE_C_STANDARD 11)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

add_compile_options(
    -Wall
    -Wextra
    -fdata-sections
    -ffunction-sections 
    -fno-exceptions
)

set(SOURCES
  src/main.c
)

add_executable(${PROJECT_NAME}.elf ${SOURCES})

#add_library()

#target_link_libraries()

#target_include_directories()

target_link_options(${PROJECT_NAME}.elf PRIVATE
    -Wl,--gc-sections
    -Wl,-Map=${PROJECT_NAME}.map
)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin 
  COMMAND ${CMAKE_SIZE} ${PROJECT_NAME}.elf
  COMMENT "Generating binary and printing size"
)

