function(target_import_c_bsp_interface target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/c-bsp-interface/include/)
    target_auto_link_lib(${target_name} c-bsp-interface ${libs_path}/c-bsp-interface/lib/)
endfunction()
