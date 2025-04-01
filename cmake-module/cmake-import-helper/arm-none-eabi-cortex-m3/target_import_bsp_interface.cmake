include(target_import_base)
include(target_import_boost)

function(target_import_bsp_interface target_name visibility)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/bsp-interface/include/)
	target_auto_link_lib(${target_name} bsp-interface $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/bsp-interface/lib/)

	target_import_base(${target_name} PUBLIC)
	target_import_boost(${target_name} PUBLIC)
endfunction()
