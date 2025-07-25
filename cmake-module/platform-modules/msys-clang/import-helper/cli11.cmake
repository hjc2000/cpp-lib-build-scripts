function(target_import_cli11 target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/cli11/include/)
endfunction()
