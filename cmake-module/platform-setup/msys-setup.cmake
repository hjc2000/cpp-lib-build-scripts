# 配置平台、工具链。
if(1)
	set(BUILD_SHARED_LIBS
		true
		CACHE STRING "是否编译动态链接库"
		FORCE)

	set(CMAKE_C_COMPILER
		"C:/msys64/ucrt64/bin/gcc.exe"
		CACHE STRING "平台"
		FORCE)

	set(CMAKE_CXX_COMPILER
		"C:/msys64/ucrt64/bin/g++.exe"
		CACHE STRING "平台"
		FORCE)

	set(CMAKE_ASM_COMPILER
		"C:/msys64/ucrt64/bin/gcc.exe"
		CACHE STRING "平台"
		FORCE)

	set(CMAKE_LINKER
		"C:/msys64/ucrt64/bin/ld.exe"
		CACHE STRING "平台"
		FORCE)

	set(CMAKE_OBJCOPY
		"C:/msys64/ucrt64/bin/objcopy.exe"
		CACHE STRING "平台"
		FORCE)

	set(CMAKE_SIZE
		"C:/msys64/ucrt64/bin/size.exe"
		CACHE STRING "平台"
		FORCE)

	set(CMAKE_STRIP
		"C:/msys64/ucrt64/bin/ld.exe"
		CACHE STRING "平台"
		FORCE)
endif()

string(
	CONCAT C_CXX_FLAGS
	" -Wall -Wextra -Wno-unused-parameter "
)

set(CMAKE_C_FLAGS ${C_CXX_FLAGS})
set(CMAKE_CXX_FLAGS ${C_CXX_FLAGS})

set(CMAKE_POSITION_INDEPENDENT_CODE true)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)


set(has_thread TRUE)

list(PREPEND CMAKE_PREFIX_PATH $ENV{cpp_lib_build_scripts_path}/${platform}/.total-install)
list(PREPEND CMAKE_PREFIX_PATH $ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/lib)
list(APPEND CMAKE_PREFIX_PATH "C:/msys64/ucrt64/lib")
list(APPEND CMAKE_PREFIX_PATH "C:/msys64/ucrt64")
message(STATUS "CMAKE_PREFIX_PATH 的值：${CMAKE_PREFIX_PATH}")
