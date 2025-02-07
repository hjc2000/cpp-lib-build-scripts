set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

# 导入我的 cmake 函数
list(APPEND CMAKE_MODULE_PATH
	 $ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions)

include(install)
include(collect)
include(link)
include(source_and_headers)
include(get_source_and_build)
include(process)

list(APPEND CMAKE_MODULE_PATH
	 $ENV{cpp_lib_build_scripts_path}/cmake-module/cmake-import-helper
	 $ENV{cpp_lib_build_scripts_path}/cmake-module/cmake-import-helper/${platform}/
	 $ENV{cpp_lib_build_scripts_path}/cmake-module/platform-setup/)

include(target_import_src)
include("${platform}-setup")



set(libs_path
	$ENV{cpp_lib_build_scripts_path}/${platform}/.libs
	CACHE STRING "库仓库路径"
	FORCE)

set(CMAKE_INSTALL_PREFIX
	${libs_path}/${ProjectName}/
	CACHE STRING "安装路径")

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
	list(APPEND CMAKE_INSTALL_RPATH
		 $ORIGIN/../lib
		 $ORIGIN/../usr/lib
		 $ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/lib
		 $ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/usr/lib)

	set(CMAKE_BUILD_WITH_INSTALL_RPATH true)

	set(CMAKE_EXE_LINKER_FLAGS
		"-Wl,-rpath-link,$ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/lib:$ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/usr/lib		${CMAKE_EXE_LINKER_FLAGS}"
		CACHE STRING "Linker flags for executables"
		FORCE)

	set(CMAKE_SHARED_LINKER_FLAGS
		"-Wl,-rpath-link,$ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/lib:$ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/usr/lib		${CMAKE_SHARED_LINKER_FLAGS}"
		CACHE STRING "Linker flags for shared libraries"
		FORCE)
endif()

# 设置CMake构建时使用的线程数
set(CMAKE_BUILD_PARALLEL_LEVEL 12)
