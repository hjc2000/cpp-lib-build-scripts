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
        message(STATUS "Including module: ${module_file}")
        include(${module_file})
    endforeach()
endfunction()
