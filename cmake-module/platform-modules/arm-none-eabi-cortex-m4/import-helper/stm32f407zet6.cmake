# region target_import_stm32f407zet6_hal
function(target_import_stm32f407zet6_hal target_name visibility)
	target_compile_definitions(
		${target_name}
		${visibility}
		USE_HAL_DRIVER=1
		STM32F407xx=1
	)

	set(lib_name "stm32f407zet6-hal")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")
endfunction()
# endregion
