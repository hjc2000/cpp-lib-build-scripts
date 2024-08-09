function(target_import_stm32f103zet6_hal target_name visibility)
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
        ${libs_path}/stm32f103zet6-hal/include
    )

    target_auto_link_lib(
        ${target_name}
        stm32f103zet6-hal
        ${libs_path}/stm32f103zet6-hal/lib/
    )
endfunction()
