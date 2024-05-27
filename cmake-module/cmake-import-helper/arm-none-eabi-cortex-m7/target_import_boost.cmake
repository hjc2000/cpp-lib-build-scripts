function(target_import_boost target_name visibility)
    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/boost/include
    )
endfunction()
