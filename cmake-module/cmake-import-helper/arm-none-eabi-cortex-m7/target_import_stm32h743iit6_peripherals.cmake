include(target_import_stm32h743iit6_hal)
include(target_import_base)
include(target_import_bsp_interface)

function(target_import_stm32h743iit6_peripherals target_name visibility)
	set(lib_name stm32h743iit6-peripherals)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include)
	target_auto_link_lib(${target_name} ${lib_name} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)

	target_import_stm32h743iit6_hal(${target_name} PRIVATE)
	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
endfunction()
