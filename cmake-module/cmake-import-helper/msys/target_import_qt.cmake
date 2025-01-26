if(MSVC)
    add_compile_options(/Zc:__cplusplus)
endif()






function(target_import_qt_core target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include)
    target_auto_link_lib(${target_name} Qt6Core ${libs_path}/qt5/lib)
endfunction()






function(target_import_qt_widgets target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include)
    target_auto_link_lib(${target_name} Qt6Widgets ${libs_path}/qt5/lib)

	# 安装 qt 运行时插件。
	install_dir(${libs_path}/qt5/plugins/platforms/ bin/platforms/ "*windows*")
endfunction()
