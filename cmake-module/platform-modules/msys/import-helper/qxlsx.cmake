function(target_import_qxlsx target_name visibility)
	set(lib_name "QXlsx")
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/QXlsxQt6)
    target_auto_link_lib(${target_name} QXlsxQt6 ${libs_path}/${lib_name}/lib/)

	target_import_qt_xml(${target_name} ${visibility})
endfunction()
