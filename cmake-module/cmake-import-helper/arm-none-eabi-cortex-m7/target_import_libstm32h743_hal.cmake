function(target_import_libstm32h743_hal target_name visibility)
    target_compile_definitions(
        ${target_name}
        ${visibility}
	    USE_HAL_DRIVER=1
	    STM32H743xx=1
    )

    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/libstm32h743-hal/include
    )

    target_auto_link_lib(
        ${target_name}
        libstm32h743-hal
        ${libs_path}/libstm32h743-hal/lib/
    )
endfunction()
