include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(Magic_Conch_default_library_list )

# Handle files with suffix s, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assemble)
add_library(Magic_Conch_default_default_AVR_GCC_assemble OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assemble})
    Magic_Conch_default_default_AVR_GCC_assemble_rule(Magic_Conch_default_default_AVR_GCC_assemble)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_assemble>")

endif()

# Handle files with suffix S, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assembleWithPreprocess)
add_library(Magic_Conch_default_default_AVR_GCC_assembleWithPreprocess OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_assembleWithPreprocess})
    Magic_Conch_default_default_AVR_GCC_assembleWithPreprocess_rule(Magic_Conch_default_default_AVR_GCC_assembleWithPreprocess)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_assembleWithPreprocess>")

endif()

# Handle files with suffix [cC], for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile)
add_library(Magic_Conch_default_default_AVR_GCC_compile OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile})
    Magic_Conch_default_default_AVR_GCC_compile_rule(Magic_Conch_default_default_AVR_GCC_compile)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_compile>")

endif()

# Handle files with suffix cpp, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile_cpp)
add_library(Magic_Conch_default_default_AVR_GCC_compile_cpp OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_compile_cpp})
    Magic_Conch_default_default_AVR_GCC_compile_cpp_rule(Magic_Conch_default_default_AVR_GCC_compile_cpp)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_compile_cpp>")

endif()

# Handle files with suffix elf, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_ihex)
add_library(Magic_Conch_default_default_AVR_GCC_objcopy_ihex OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_ihex})
    Magic_Conch_default_default_AVR_GCC_objcopy_ihex_rule(Magic_Conch_default_default_AVR_GCC_objcopy_ihex)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_objcopy_ihex>")

endif()

# Handle files with suffix elf, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_eep)
add_library(Magic_Conch_default_default_AVR_GCC_objcopy_eep OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_eep})
    Magic_Conch_default_default_AVR_GCC_objcopy_eep_rule(Magic_Conch_default_default_AVR_GCC_objcopy_eep)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_objcopy_eep>")

endif()

# Handle files with suffix elf, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_lss)
add_library(Magic_Conch_default_default_AVR_GCC_objcopy_lss OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_lss})
    Magic_Conch_default_default_AVR_GCC_objcopy_lss_rule(Magic_Conch_default_default_AVR_GCC_objcopy_lss)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_objcopy_lss>")

endif()

# Handle files with suffix elf, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_srec)
add_library(Magic_Conch_default_default_AVR_GCC_objcopy_srec OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_srec})
    Magic_Conch_default_default_AVR_GCC_objcopy_srec_rule(Magic_Conch_default_default_AVR_GCC_objcopy_srec)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_objcopy_srec>")

endif()

# Handle files with suffix elf, for group default-AVR-GCC
if(Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_sig)
add_library(Magic_Conch_default_default_AVR_GCC_objcopy_sig OBJECT ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_objcopy_sig})
    Magic_Conch_default_default_AVR_GCC_objcopy_sig_rule(Magic_Conch_default_default_AVR_GCC_objcopy_sig)
    list(APPEND Magic_Conch_default_library_list "$<TARGET_OBJECTS:Magic_Conch_default_default_AVR_GCC_objcopy_sig>")

endif()


# Main target for this project
add_executable(Magic_Conch_default_image_Pl3_RbB_ ${Magic_Conch_default_library_list})

set_target_properties(Magic_Conch_default_image_Pl3_RbB_ PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    ADDITIONAL_CLEAN_FILES "${output_extensions}"
    RUNTIME_OUTPUT_DIRECTORY "${Magic_Conch_default_output_dir}")
target_link_libraries(Magic_Conch_default_image_Pl3_RbB_ PRIVATE ${Magic_Conch_default_default_AVR_GCC_FILE_TYPE_link})

#Add objcopy steps
Magic_Conch_default_objcopy_ihex_rule(Magic_Conch_default_image_Pl3_RbB_)
Magic_Conch_default_objcopy_eep_rule(Magic_Conch_default_image_Pl3_RbB_)
Magic_Conch_default_objcopy_lss_rule(Magic_Conch_default_image_Pl3_RbB_)
Magic_Conch_default_objcopy_srec_rule(Magic_Conch_default_image_Pl3_RbB_)
Magic_Conch_default_objcopy_sig_rule(Magic_Conch_default_image_Pl3_RbB_)
# Add the link options from the rule file.
Magic_Conch_default_link_rule( Magic_Conch_default_image_Pl3_RbB_)


