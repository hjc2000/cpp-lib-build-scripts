include(target_import_base)
include(target_import_bsp_interface)
include(target_import_stm32f103zet6_hal)
include(target_import_task)

function(target_import_stm32f103zet6_serial target_name visibility)
	set(lib_name "stm32f103zet6-serial")
    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
    target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)
    install_dll_dir(${libs_path}/${lib_name}/bin/)

    target_import_base(${target_name} ${visibility})
    target_import_bsp_interface(${target_name} ${visibility})
	target_import_task(${target_name} ${visibility})
	target_import_stm32f103zet6_hal(${target_name} PRIVATE)
endfunction()
