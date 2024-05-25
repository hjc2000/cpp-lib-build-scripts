# 导入我的 cmake 函数
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
	${cpp_lib_build_scripts_path}/cmake-module/cmake-import-helper/${platform}/
	${cpp_lib_build_scripts_path}/cmake-module/platform-setup/
)
include(target_import_src)
include("${platform}-setup")



set(
	libs_path 
	${cpp_lib_build_scripts_path}/${platform}/.libs 
	CACHE STRING "库仓库路径"
)
message(STATUS "库仓库路径：${libs_path}")

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
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
