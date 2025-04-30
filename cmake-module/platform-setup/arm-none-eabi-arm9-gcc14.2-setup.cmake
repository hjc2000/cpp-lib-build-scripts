# region 配置平台、工具链。

set(BUILD_SHARED_LIBS
	false
	CACHE STRING "是否编译动态链接库"
	FORCE)

set(CMAKE_SYSTEM_NAME
	"Generic"
	CACHE STRING "平台"
	FORCE)

set(tool_chain_root_path "$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin")

set(CMAKE_C_COMPILER
	"${tool_chain_root_path}/arm-none-eabi-gcc.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_CXX_COMPILER
	"${tool_chain_root_path}/arm-none-eabi-g++.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_ASM_COMPILER
	"${tool_chain_root_path}/arm-none-eabi-gcc.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_LINKER
	"${tool_chain_root_path}/arm-none-eabi-ld.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_OBJCOPY
	"${tool_chain_root_path}/arm-none-eabi-objcopy.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_SIZE
	"${tool_chain_root_path}/arm-none-eabi-size.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_STRIP
	"${tool_chain_root_path}/arm-none-eabi-ld.exe"
	CACHE STRING "平台"
	FORCE)

# endregion




# 添加查找库的路径。
# cmake 会从 CMAKE_PREFIX_PATH 路径列表里面的路径查找库、包等。
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path})
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path}/lib)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
