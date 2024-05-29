function(target_import_freertos_gcc_cm7 target_name visibility)
    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/freertos-gcc-cm7/include
    )

    target_auto_link_lib(
        ${target_name}
        freertos-gcc-cm7
        ${libs_path}/freertos-gcc-cm7/lib/
    )
endfunction()
