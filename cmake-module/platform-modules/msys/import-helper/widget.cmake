function(target_import_widget target_name visibility)
	set(lib_name "widget")

    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_add_source_files_recurse(${target_name} "${libs_path}/${lib_name}/obj/")

	target_import_base(${target_name} ${visibility})
	target_import_base_filesystem(${ProjectName} ${visibility})
	target_import_qt_widgets(${target_name} ${visibility})
	target_import_qt_opengl(${target_name} ${visibility})
	target_import_qwt(${target_name} ${visibility})
	target_import_qxlsx(${target_name} ${visibility})
	target_import_qt_serial_port(${target_name} ${visibility})
endfunction()
