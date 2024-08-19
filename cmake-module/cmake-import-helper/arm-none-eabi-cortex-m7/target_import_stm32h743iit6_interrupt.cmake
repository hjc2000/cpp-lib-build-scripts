function(target_import_stm32h743iit6_interrupt target_name visibility)
    target_compile_definitions(
        ${target_name}
        ${visibility}
	    USE_HAL_DRIVER=1
	    STM32H743xx=1
    )

	set(lib_name stm32h743iit6-interrupt)
    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
    target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)
endfunction()
