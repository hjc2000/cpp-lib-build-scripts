function(target_import_stm32f103_lvgl target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/stm32f103-lvgl/include/)
    target_auto_link_lib(${target_name} stm32f103-lvgl ${libs_path}/stm32f103-lvgl/lib/)
endfunction()
