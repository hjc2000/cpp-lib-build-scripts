include(target_import_base)
include(target_import_qt)

function(target_import_widget target_name visibility)
	set(lib_name "widget")
    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
    target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_base(${target_name} ${visibility})
	target_import_qt_widgets(${target_name} PUBLIC)
	target_import_qt_opengl(${target_name} PUBLIC)
	target_import_qwt(${target_name} PUBLIC)
endfunction()
