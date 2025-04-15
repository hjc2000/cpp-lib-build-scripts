# region 配置平台、工具链。

set(BUILD_SHARED_LIBS
	false
	CACHE STRING "是否编译动态链接库"
	FORCE)

set(CMAKE_SYSTEM_PROCESSOR
	"arm"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_SYSTEM_ARCH
	"armv7-m"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_SYSTEM_NAME
	"Generic"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_C_COMPILER
	"$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin/arm-none-eabi-gcc.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_CXX_COMPILER
	"$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin/arm-none-eabi-g++.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_ASM_COMPILER
	"$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin/arm-none-eabi-gcc.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_LINKER
	"$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin/arm-none-eabi-ld.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_OBJCOPY
	"$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin/arm-none-eabi-objcopy.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_SIZE
	"$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin/arm-none-eabi-size.exe"
	CACHE STRING "平台"
	FORCE)

set(CMAKE_STRIP
	"$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/bin/arm-none-eabi-ld.exe"
	CACHE STRING "平台"
	FORCE)

# endregion

# 编译，链接选项
# 需要在任何一个 project 函数的调用之前调用，否则 cmake 会报错，
# 说编译器无法编译测试程序。
string(
	CONCAT c_cpp_flags
	" -mcpu=Cortex-M7 -mthumb "
	" -mfloat-abi=hard -mfpu=fpv5-sp-d16 "
	" -nodefaultlibs "
)
string(
	CONCAT cpp_flags
	" -fexceptions "
	" -fno-rtti "
)
set(CMAKE_C_FLAGS ${c_cpp_flags})
set(CMAKE_CXX_FLAGS "${c_cpp_flags} ${cpp_flags}")

# 特定于可执行文件的链接选项
string(
	CONCAT CMAKE_EXE_LINKER_FLAGS
	" -Wl,-Map=out_map.map "
	" -Wl,--gc-sections "
	" -static "
)
# 检查链接脚本文件是否存在
if(EXISTS "${CMAKE_SOURCE_DIR}/link_script.ld")
	# 文件存在，添加 -T 选项及链接脚本路径到 CMAKE_EXE_LINKER_FLAGS
	string(
		APPEND CMAKE_EXE_LINKER_FLAGS
		" -T${CMAKE_SOURCE_DIR}/link_script.ld "
	)
endif()

# 添加查找库的路径。
# cmake 会从 CMAKE_PREFIX_PATH 路径列表里面的路径查找库、包等。
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path})
list(PREPEND CMAKE_PREFIX_PATH ${total_install_path}/lib)


function(target_set_platform_compile_options target_name)
    # 定义通用的 C/C++ 编译选项
    set(c_cpp_flags
        -Wall -Wextra -Wno-unused-parameter
        -mcpu=Cortex-M7 -mthumb
        -fno-strict-aliasing
        -ffunction-sections
        -fdata-sections
        -mfloat-abi=hard -mfpu=fpv5-sp-d16
        -nodefaultlibs
    )

    # 定义 C++ 特定的编译选项
    set(cpp_flags
        -fexceptions
        -fno-rtti
    )

    # 定义汇编器相关的编译选项
    set(asm_flags
        -x assembler-with-cpp
    )

    # 为目标设置通用的编译选项
    target_compile_options(${target_name} PRIVATE ${c_cpp_flags})

    # 为 C++ 源文件追加额外的编译选项
    target_compile_options(${target_name} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${cpp_flags}>)

    # 为汇编源文件追加额外的编译选项
    target_compile_options(${target_name} PRIVATE $<$<COMPILE_LANGUAGE:ASM>:${asm_flags}>)
endfunction()
