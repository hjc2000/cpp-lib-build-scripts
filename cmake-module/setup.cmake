# region cmake_import_all_module

#
# cmake_import_all_module 函数
#
# 该函数用于导入指定目录下的所有 .cmake 文件。
# 可以选择是否递归地搜索子目录中的 .cmake 文件。
#
# 参数:
# - DIRECTORY: 要搜索的根目录路径。
# - RECURSIVE: 是否递归搜索子目录中的 .cmake 文件 (TRUE 或 FALSE)。
#
# 示例项目结构:
# project/
# ├── CMakeLists.txt
# └── cmake_scripts/
#     ├── module1.cmake
#     └── subdir/
#         └── module2.cmake
#
# 示例调用:
# # 导入 cmake_scripts 目录下的所有 .cmake 文件（非递归）
# cmake_import_all_module("${CMAKE_SOURCE_DIR}/cmake_scripts" FALSE)
#
# # 导入 cmake_scripts 目录及其子目录下的所有 .cmake 文件（递归）
# cmake_import_all_module("${CMAKE_SOURCE_DIR}/cmake_scripts" TRUE)
#
function(cmake_import_all_module DIRECTORY RECURSIVE)
    # 参数检查
    if(NOT IS_DIRECTORY ${DIRECTORY})
        message(WARNING "Directory does not exist: ${DIRECTORY}")
        return()
    endif()

    # 根据是否递归选择 GLOB 或 GLOB_RECURSE
    if(RECURSIVE)
        file(GLOB_RECURSE CMAKE_MODULE_FILES "${DIRECTORY}/*.cmake")
    else()
        file(GLOB CMAKE_MODULE_FILES "${DIRECTORY}/*.cmake")
    endif()

    # 如果没有找到任何 .cmake 文件，打印警告信息
    if(NOT CMAKE_MODULE_FILES)
        message(WARNING "No .cmake files found in directory: ${DIRECTORY}")
        return()
    endif()

    # 遍历所有找到的 .cmake 文件并 include 它们
    foreach(module_file IN LISTS CMAKE_MODULE_FILES)
        include(${module_file})
    endforeach()
endfunction()

# endregion



if("${ProjectName}" STREQUAL "")
	message(FATAL_ERROR "ProjectName 没有被设置。")
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")


# 设置CMake构建时使用的线程数
set(CMAKE_BUILD_PARALLEL_LEVEL 12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)



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





# region 导入我的 cmake 函数

# 通用
cmake_import_all_module("$ENV{cpp_lib_build_scripts_path}/cmake-module/cmake-function/" FALSE)

# 平台特定
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/platform-setup/${platform}-setup.cmake")
cmake_import_all_module("$ENV{cpp_lib_build_scripts_path}/cmake-module/platform-cmake-function/${platform}/" TRUE)

# endregion
