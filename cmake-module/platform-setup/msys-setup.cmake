# region 配置平台、工具链

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

# endregion

string(
	CONCAT c_cpp_flags
	" -Wall -Wextra -Wno-unused-parameter "
)

set(CMAKE_C_FLAGS ${c_cpp_flags})
set(CMAKE_CXX_FLAGS ${c_cpp_flags})


set(has_thread TRUE)

# 添加查找库的路径。
# cmake 会从 CMAKE_PREFIX_PATH 路径列表里面的路径查找库、包等。
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path})
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path}/lib)
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path}/lib/cmake)
list(APPEND CMAKE_PREFIX_PATH "C:/msys64/ucrt64/lib")
list(APPEND CMAKE_PREFIX_PATH "C:/msys64/ucrt64/lib/cmake")
list(APPEND CMAKE_PREFIX_PATH "C:/msys64/ucrt64")
message(STATUS "CMAKE_PREFIX_PATH 的值：${CMAKE_PREFIX_PATH}")
