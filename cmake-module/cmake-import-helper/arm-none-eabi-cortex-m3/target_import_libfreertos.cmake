function(target_import_libfreertos target_name visibility)
    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/libfreertos/include
    )

    target_auto_link_lib(
        ${target_name}
        libfreertos
        ${libs_path}/libfreertos/lib/
    )
endfunction()
