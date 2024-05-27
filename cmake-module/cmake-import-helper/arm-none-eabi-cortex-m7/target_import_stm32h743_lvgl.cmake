function(target_import_stm32h743_lvgl target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/stm32h743-lvgl/include/)
    target_auto_link_lib(${target_name} stm32h743-lvgl ${libs_path}/stm32h743-lvgl/lib/)
endfunction()
