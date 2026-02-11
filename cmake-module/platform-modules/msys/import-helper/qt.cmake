if(MSVC)
    add_compile_options(/Zc:__cplusplus)
endif()





function(target_import_qt_core target_name visibility)
	# if(NOT CMAKE_AUTOMOC)
	# 	set(CMAKE_AUTOMOC ON CACHE STRING "启用 moc")
	# 	find_package(Qt6 COMPONENTS Core REQUIRED)
	# 	message(STATUS "启用 moc")
	# endif()

    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtCore)
    target_auto_link_lib(${target_name} Qt6Core ${libs_path}/qt5/lib)
    target_auto_link_lib(${target_name} qwindows ${libs_path}/qt5/plugins/platforms)

	target_link_libraries(${target_name} ${visibility}
		setupapi
		z
		synchronization
		pcre2-16
		double-conversion
		ntdll
		version
		harfbuzz
		b2
		zstd
		netapi32
		authz
		ws2_32
		winmm
		userenv
		dwrite
		png
		md4c
		d3d12
		dxgi
		d3d11
		wtsapi32
		imm32
		freetype
		shcore
		dwmapi
		d3d9
		shlwapi
		runtimeobject
		uxtheme
	)
endfunction()






function(target_import_qt_widgets target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtWidgets)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtGui)

    target_auto_link_lib(${target_name} Qt6Widgets ${libs_path}/qt5/lib)
    target_auto_link_lib(${target_name} Qt6Gui ${libs_path}/qt5/lib)

	target_import_qt_core(${target_name} ${visibility})
endfunction()




function(target_import_qt_opengl target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtOpenGL)

    target_auto_link_lib(${target_name} Qt6OpenGL ${libs_path}/qt5/lib)
    target_auto_link_lib(${target_name} Qt6OpenGLWidgets ${libs_path}/qt5/lib)

	target_import_qt_widgets(${target_name} ${visibility})
endfunction()




function(target_import_qt_xml target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtXml)

    target_auto_link_lib(${target_name} Qt6Xml ${libs_path}/qt5/lib)

	target_import_qt_core(${target_name} ${visibility})
endfunction()



# qwt 是一个基于 qt 的绘制函数曲线的库。
function(target_import_qwt target_name visibility)
	target_link_libraries(${target_name} ${visibility} qwt-qt6)
	target_import_qt_widgets(${target_name} ${visibility})
endfunction()



# 导入串口库
function(target_import_qt_serial_port target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/qt5/include/QtSerialPort)

    target_auto_link_lib(${target_name} Qt6SerialPort ${libs_path}/qt5/lib)

	target_import_qt_core(${target_name} ${visibility})
endfunction()
