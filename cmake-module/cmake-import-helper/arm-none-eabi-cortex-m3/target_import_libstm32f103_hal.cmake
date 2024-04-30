function(target_import_libstm32f103_hal target_name visibility)
    target_compile_definitions(
        ${target_name}
        ${visibility}
	    USE_HAL_DRIVER=1
	    STM32F103xE=1
	    STM32F10X_HD=1
	    ARM_MATH_CM3
	    ARM_MATH_MATRIX_CHECK
	    ARM_MATH_ROUNDING
	    UNALIGNED_SUPPORT_DISABLE
    )

    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/libstm32f103-hal/include
    )

    target_auto_link_lib(
        ${target_name}
        ${visibility}
        libstm32f103-hal
        ${libs_path}/libstm32f103-hal/lib/
    )
endfunction()
