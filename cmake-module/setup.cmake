# 安装时是否安装头文件。默认会安装。
option(option_install_headers true)



# 导入我的 cmake 函数
if(1)
	list(
		APPEND CMAKE_MODULE_PATH 
		${cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions
	)
	include(install)
	include(collect)
	include(link)
	include(source_and_headers)
	include(get_source_and_build)
	include(process)

	list(
		APPEND CMAKE_MODULE_PATH
		${cpp_lib_build_scripts_path}/cmake-module/cmake-import-helper
	)
	include(target_import_src)
endif()




# 库仓库的路径
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
	set(
		libs_path 
		${cpp_lib_build_scripts_path}/${platform}/.libs 
		CACHE STRING "库仓库路径"
	)
	message(STATUS "库仓库路径：${libs_path}")
else()
	set(
		libs_path 
		${cpp_lib_build_scripts_path}/${platform}/.libs 
		CACHE STRING "库仓库路径"
	)
	message(STATUS "库仓库路径：${libs_path}")

	list(
		APPEND CMAKE_INSTALL_RPATH
		$ORIGIN/../lib
		$ORIGIN/../usr/lib
		${cpp_lib_build_scripts_path}/${platform}/.total-install/lib
		${cpp_lib_build_scripts_path}/${platform}/.total-install/usr/lib
	)
	set(CMAKE_BUILD_WITH_INSTALL_RPATH true)

	set(
		CMAKE_EXE_LINKER_FLAGS
		"-Wl,-rpath-link,${cpp_lib_build_scripts_path}/${platform}/.total-install/lib:${cpp_lib_build_scripts_path}/${platform}/.total-install/usr/lib		${CMAKE_EXE_LINKER_FLAGS}"
		CACHE STRING "Linker flags for executables"
		FORCE
	)
	set(CMAKE_SHARED_LINKER_FLAGS
		"-Wl,-rpath-link,${cpp_lib_build_scripts_path}/${platform}/.total-install/lib:${cpp_lib_build_scripts_path}/${platform}/.total-install/usr/lib		${CMAKE_SHARED_LINKER_FLAGS}"
		CACHE STRING "Linker flags for shared libraries"
		FORCE
	)
endif()
