# region 配置平台、工具链

set(BUILD_SHARED_LIBS
	true
	CACHE STRING "是否编译动态链接库"
	FORCE)

set(tool_chain_root_path "C:/msys64/ucrt64/bin")

set(CMAKE_C_COMPILER
	"${tool_chain_root_path}/gcc.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_CXX_COMPILER
	"${tool_chain_root_path}/g++.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_ASM_COMPILER
	"${tool_chain_root_path}/gcc.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_LINKER
	"${tool_chain_root_path}/ld.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_OBJCOPY
	"${tool_chain_root_path}/objcopy.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_SIZE
	"${tool_chain_root_path}/size.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_STRIP
	"${tool_chain_root_path}/ld.exe"
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

# 生成位置无关代码
set(CMAKE_POSITION_INDEPENDENT_CODE true)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)
