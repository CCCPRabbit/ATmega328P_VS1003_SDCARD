# The following variables contains the files used by the different stages of the build process.
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assemble)
set_source_files_properties(${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assemble} PROPERTIES LANGUAGE ASM)

# For assembly files, add "." to the include path for each file so that .include with a relative path works
foreach(source_file ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assemble})
        set_source_files_properties(${source_file} PROPERTIES INCLUDE_DIRECTORIES "$<PATH:NORMAL_PATH,$<PATH:REMOVE_FILENAME,${source_file}>>")
endforeach()

set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assembleWithPreprocess)
set_source_files_properties(${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assembleWithPreprocess} PROPERTIES LANGUAGE ASM)

# For assembly files, add "." to the include path for each file so that .include with a relative path works
foreach(source_file ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assembleWithPreprocess})
        set_source_files_properties(${source_file} PROPERTIES INCLUDE_DIRECTORIES "$<PATH:NORMAL_PATH,$<PATH:REMOVE_FILENAME,${source_file}>>")
endforeach()

set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../diskio.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../ff.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../ffunicode_avr.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../main.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../mmc_avr_spi.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../spi.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../usart_interrupt.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../vs1003.c")
set_source_files_properties(${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile} PROPERTIES LANGUAGE C)
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile_cpp)
set_source_files_properties(${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile_cpp} PROPERTIES LANGUAGE CXX)
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_link)
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_ihex)
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_eep)
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_lss)
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_srec)
set(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_sig)
set(Magic_Conch_default_image_name "default.elf")
set(Magic_Conch_default_image_base_name "default")

# The output directory of the final image.
set(Magic_Conch_default_output_dir "${CMAKE_CURRENT_SOURCE_DIR}/../../../out/Magic_Conch")

# The full path to the final image.
set(Magic_Conch_default_full_path_to_image ${Magic_Conch_default_output_dir}/${Magic_Conch_default_image_name})

# Potential output file extensions
set(output_extensions
    .hex
    .lss
    .eep
    .srec
    .usersignatures)
list(TRANSFORM output_extensions PREPEND "${Magic_Conch_default_output_dir}/${Magic_Conch_default_image_base_name}")
