function(target_import_stm32h743iit6_hal target_name visibility)
	target_compile_definitions(
		${target_name}
		${visibility}
		USE_HAL_DRIVER=1
		STM32H743xx=1
	)

	set(lib_name stm32h743iit6-hal)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)
endfunction()
