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

	target_include_directories(${target_name} ${visibility}	${libs_path}/stm32f103zet6-hal/include)
	target_auto_link_lib(${target_name}	stm32f103zet6-hal ${libs_path}/stm32f103zet6-hal/lib/)
endfunction()

function(target_import_stm32f103zet6_interrupt target_name visibility)
	target_include_directories(${target_name} ${visibility} ${libs_path}/stm32f103zet6-interrupt/include/)
	target_auto_link_lib(${target_name} stm32f103zet6-interrupt ${libs_path}/stm32f103zet6-interrupt/lib/)

	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
	target_import_stm32f103zet6_hal(${target_name} PRIVATE)
endfunction()

function(target_import_stm32f103zet6_serial target_name visibility)
	set(lib_name "stm32f103zet6-serial")
	target_include_directories(${target_name} ${visibility} "${libs_path}/${lib_name}/include/")
	target_auto_link_lib(${target_name} ${lib_name} "${libs_path}/${lib_name}/lib/")

	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
	target_import_task(${target_name} ${visibility})
	target_import_stm32f103zet6_hal(${target_name} PRIVATE)
endfunction()

function(target_import_stm32f103zet6_timer target_name visibility)
	set(lib_name "stm32f103zet6-timer")
	target_include_directories(${target_name} ${visibility} "${libs_path}/${lib_name}/include/")
	target_auto_link_lib(${target_name} ${lib_name} "${libs_path}/${lib_name}/lib/")

	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
	target_import_stm32f103zet6_hal(${target_name} PRIVATE)
endfunction()

function(target_import_stm32f103zet6_dma target_name visibility)
	set(lib_name stm32f103zet6-dma)
	target_include_directories(${target_name} ${visibility} "${libs_path}/${lib_name}/include/")
	target_auto_link_lib(${target_name} ${lib_name} "${libs_path}/${lib_name}/lib/")

	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
	target_import_stm32f103zet6_hal(${target_name} PRIVATE)
endfunction()

function(target_import_stm32f103zet6_gpio target_name visibility)
	target_include_directories(${target_name} ${visibility} ${libs_path}/stm32f103zet6-gpio/include/)
	target_auto_link_lib(${target_name} stm32f103zet6-gpio ${libs_path}/stm32f103zet6-gpio/lib/)

	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
	target_import_stm32f103zet6_hal(${target_name} PRIVATE)
endfunction()

function(target_import_stm32f103_lvgl target_name visibility)
	target_include_directories(${target_name} ${visibility} ${libs_path}/stm32f103-lvgl/include/)
	target_auto_link_lib(${target_name} stm32f103-lvgl ${libs_path}/stm32f103-lvgl/lib/)
endfunction()
