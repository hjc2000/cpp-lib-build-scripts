function(target_import_libstm32f103_hal target_name visibility)
    target_compile_definitions(
	    ${ProjectName}
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

    target_link_libraries(
        ${target_name}
        ${visibility}
        ${libs_path}/libstm32f103-hal/lib/libstm32f103-hal.a
    )

    install(
        FILES ${libs_path}/libstm32f103-hal/lib/libstm32f103-hal.a
        DESTINATION lib
    )
endfunction()
