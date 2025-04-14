# region 配置平台、工具链

set(BUILD_SHARED_LIBS
	true
	CACHE STRING "是否编译动态链接库"
	FORCE)

set(CMAKE_C_COMPILER
	"gcc"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_CXX_COMPILER
	"g++"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_ASM_COMPILER
	"gcc"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_LINKER
	"ld"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_OBJCOPY
	"objcopy"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_SIZE
	"size"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_STRIP
	"ld"
	CACHE STRING "平台"
	FORCE)

# endregion

string(
	CONCAT c_cpp_flags
	" -Wall -Wextra -Wno-unused-parameter "
)
set(CMAKE_C_FLAGS ${c_cpp_flags})
set(CMAKE_CXX_FLAGS ${c_cpp_flags})

string(
	CONCAT exe_so_linker_flags
	# 让构建时链接器链接时就能查找指定的 rpath, 不然只有操作系统的运行时链接器会使用 rpath.
	" -Wl,-rpath-link,${total_install_path}/lib:${total_install_path}/usr/lib "
)

set(CMAKE_EXE_LINKER_FLAGS
	"${exe_so_linker_flags} ${CMAKE_EXE_LINKER_FLAGS}"
	CACHE STRING "可执行文件连接标志"
	FORCE)

set(CMAKE_SHARED_LINKER_FLAGS
	"${exe_so_linker_flags} ${CMAKE_SHARED_LINKER_FLAGS}"
	CACHE STRING "动态库链接标志"
	FORCE)


# 定义通用的 RPATH 列表
list(APPEND build_and_install_rpaths
    "$ORIGIN"
    "$ORIGIN/../lib"
    "$ORIGIN/../usr/lib"
    "${total_install_path}/lib"
    "${total_install_path}/usr/lib")

# 设置构建阶段的 RPATH
list(APPEND CMAKE_BUILD_RPATH ${build_and_install_rpaths})

# 设置安装阶段的 RPATH
list(APPEND CMAKE_INSTALL_RPATH ${build_and_install_rpaths})

# 打印调试信息
message(STATUS "CMAKE_BUILD_RPATH: ${CMAKE_BUILD_RPATH}")
message(STATUS "CMAKE_INSTALL_RPATH: ${CMAKE_INSTALL_RPATH}")



set(has_thread TRUE)

# 添加查找库的路径。
# cmake 会从 CMAKE_PREFIX_PATH 路径列表里面的路径查找库、包等。
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path})
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path}/lib)
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path}/lib/cmake)
list(APPEND CMAKE_PREFIX_PATH "/usr/lib")
message(STATUS "CMAKE_PREFIX_PATH 的值：${CMAKE_PREFIX_PATH}")
