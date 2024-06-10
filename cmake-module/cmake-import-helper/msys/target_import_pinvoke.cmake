function(target_import_pinvoke target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/pinvoke/include/)
    target_auto_link_lib(${target_name} pinvoke ${libs_path}/pinvoke/lib/)
    install_dll_dir(${libs_path}/pinvoke/bin/)

	target_import_base(${target_name} ${visibility})
	target_import_jccpp(${target_name} ${visibility})
endfunction()