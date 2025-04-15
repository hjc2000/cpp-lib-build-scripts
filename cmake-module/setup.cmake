if("${ProjectName}" STREQUAL "")
	message(FATAL_ERROR "ProjectName 没有被设置。")
endif()

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")




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
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/base-cmake-functions.cmake")
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/install.cmake")
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/link.cmake")
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/CMakeFunctions/source_and_headers.cmake")

# 平台特定
include("$ENV{cpp_lib_build_scripts_path}/cmake-module/platform-setup/${platform}-setup.cmake")
cmake_import_all_module($ENV{cpp_lib_build_scripts_path}/cmake-module/cmake-import-helper/${platform}/ FALSE)

# endregion




# 设置CMake构建时使用的线程数
set(CMAKE_BUILD_PARALLEL_LEVEL 12)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)




# region target_set_compile_options

function(target_set_compile_options target_name)
    # 定义通用的 C/C++ 编译选项
    set(c_cpp_flags
        -Wall -Wextra -Wno-unused-parameter
        -fno-strict-aliasing
        -ffunction-sections
        -fdata-sections
    )

    # 定义汇编器相关的编译选项
    set(asm_flags
        -x assembler-with-cpp
    )

    # 为目标设置通用的编译选项
    target_compile_options(${target_name} PRIVATE ${c_cpp_flags})

    # 为汇编源文件追加额外的编译选项
    target_compile_options(${target_name} PRIVATE $<$<COMPILE_LANGUAGE:ASM>:${asm_flags}>)
endfunction()

# endregion
