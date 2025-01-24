include(target_import_base)
include(target_import_bsp_interface)
include(target_import_stm32h743iit6_hal)

function(target_import_stm32h743iit6_clock target_name visibility)
	set(lib_name "stm32h743iit6-clock")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
	target_import_stm32h743iit6_hal(${target_name} PRIVATE)
endfunction()
