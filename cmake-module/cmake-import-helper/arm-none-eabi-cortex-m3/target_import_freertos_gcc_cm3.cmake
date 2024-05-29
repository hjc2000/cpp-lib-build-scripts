function(target_import_freertos_gcc_cm3 target_name visibility)
    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/freertos-gcc-cm3/include
    )

    target_auto_link_lib(
        ${target_name}
        freertos-gcc-cm3
        ${libs_path}/freertos-gcc-cm3/lib/
    )
endfunction()
