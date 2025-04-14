if("${ProjectName}" STREQUAL "")
	message(FATAL_ERROR "ProjectName 没有被设置。")
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

# region 导入我的 cmake 函数

# 通用
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/base-cmake-functions.cmake")
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/install.cmake")
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/link.cmake")
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/source_and_headers.cmake")

# 平台特定
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/platform-setup/${platform}-setup.cmake")
cmake_import_all_module($ENV{cpp_lib_build_scripts_path}/cmake-module/cmake-import-helper/${platform}/ FALSE)

# endregion

# region 路径变量定义

set(libs_path
	$ENV{cpp_lib_build_scripts_path}/${platform}/.libs
	CACHE STRING "各个库的预编译安装路径"
	FORCE)

set(repos_path
	$ENV{cpp_lib_build_scripts_path}/${platform}/.repos
	CACHE STRING "各个库的源码路径"
	FORCE)

set(total_install_path
	$ENV{cpp_lib_build_scripts_path}/${platform}/.total-install
	CACHE STRING "各个库的源码路径"
	FORCE)

set(CMAKE_INSTALL_PREFIX
	${libs_path}/${ProjectName}/
	CACHE STRING "安装路径"
	FORCE)

# endregion

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
	list(APPEND CMAKE_INSTALL_RPATH
		 $ORIGIN/../lib
		 $ORIGIN/../usr/lib
		 ${total_install_path}/lib
		 ${total_install_path}/usr/lib)

	set(CMAKE_BUILD_WITH_INSTALL_RPATH true)

	set(CMAKE_EXE_LINKER_FLAGS
		"-Wl,-rpath-link,${total_install_path}/lib:${total_install_path}/usr/lib		${CMAKE_EXE_LINKER_FLAGS}"
		CACHE STRING "Linker flags for executables"
		FORCE)

	set(CMAKE_SHARED_LINKER_FLAGS
		"-Wl,-rpath-link,${total_install_path}/lib:${total_install_path}/usr/lib		${CMAKE_SHARED_LINKER_FLAGS}"
		CACHE STRING "Linker flags for shared libraries"
		FORCE)
endif()

# 设置CMake构建时使用的线程数
set(CMAKE_BUILD_PARALLEL_LEVEL 12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 生成位置无关代码
set(CMAKE_POSITION_INDEPENDENT_CODE true)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)
