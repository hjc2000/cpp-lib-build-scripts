if(MSVC)
    add_compile_options(/Zc:__cplusplus)
endif()



set(CMAKE_AUTOMOC ON)
find_package(Qt6 COMPONENTS Core REQUIRED)



function(target_import_qt_core target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtCore)
    target_auto_link_lib(${target_name} Qt6Core ${libs_path}/qt5/lib)
endfunction()






function(target_import_qt_widgets target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtWidgets)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtGui)

    target_auto_link_lib(${target_name} Qt6Widgets ${libs_path}/qt5/lib)
    target_auto_link_lib(${target_name} Qt6Gui ${libs_path}/qt5/lib)

	target_import_qt_core(${target_name} ${visibility})

	# 安装 qt 运行时插件。
	install_dir(${libs_path}/qt5/plugins/platforms/ bin/platforms/ "*windows*")
endfunction()




function(target_import_qt_opengl target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtOpenGL)

    target_auto_link_lib(${target_name} Qt6OpenGL ${libs_path}/qt5/lib)
    target_auto_link_lib(${target_name} Qt6OpenGLWidgets ${libs_path}/qt5/lib)

	target_import_qt_widgets(${target_name} ${visibility})
endfunction()



# qwt 是一个基于 qt 的绘制函数曲线的库。
function(target_import_qwt target_name visibility)
	target_link_libraries(${target_name} PUBLIC qwt-qt6)
	target_import_qt_widgets(${target_name} ${visibility})
endfunction()
