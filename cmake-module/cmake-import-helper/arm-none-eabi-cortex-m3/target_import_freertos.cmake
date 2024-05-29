function(target_import_freertos target_name visibility)
    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/freertos/include
    )

    target_auto_link_lib(
        ${target_name}
        freertos
        ${libs_path}/freertos/lib/
    )
endfunction()
