include(target_import_base)
include(target_import_boost)

function(target_import_bsp_interface target_name visibility)
	target_include_directories(${target_name} ${visibility} ${libs_path}/bsp-interface/include/)
	target_auto_link_lib(${target_name} bsp-interface ${libs_path}/bsp-interface/lib/)
	install_dll_dir(${libs_path}/bsp-interface/bin/)

	target_import_base(${target_name} PUBLIC)
	target_import_boost(${target_name} PUBLIC)
endfunction()
