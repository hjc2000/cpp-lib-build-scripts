include(target_import_base)
include(target_import_bsp_interface)
include(target_import_stm32f103zet6_hal)

function(target_import_stm32f103zet6_interrupt target_name visibility)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/stm32f103zet6-interrupt/include/)
	target_auto_link_lib(${target_name} stm32f103zet6-interrupt $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/stm32f103zet6-interrupt/lib/)

	target_import_base(${target_name} ${visibility})
	target_import_bsp_interface(${target_name} ${visibility})
	target_import_stm32f103zet6_hal(${target_name} PRIVATE)
endfunction()
