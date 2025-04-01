include(target_import_qt)

function(target_import_qxlsx target_name visibility)
	set(lib_name "QXlsx")
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include/)
	target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/include/QXlsxQt6)
    target_auto_link_lib(${target_name} QXlsxQt6 $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/${lib_name}/lib/)

	target_import_qt_xml(${target_name} ${visibility})
endfunction()
