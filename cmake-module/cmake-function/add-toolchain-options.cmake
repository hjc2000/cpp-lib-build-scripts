# region target_add_compile_options

# 添加所有平台通用的编译器选项。
function(target_add_compile_options target_name)
    # 定义通用的 C/C++ 编译选项
    set(c_cpp_flags
        -Wall -Wextra -Wno-unused-parameter
        -fno-strict-aliasing
        -ffunction-sections
        -fdata-sections
		-fmessage-length=0
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




# region target_add_link_options_when_it_is_exe

function(target_add_link_options_when_it_is_exe target_name)
    get_target_property(target_type ${target_name} TYPE)
	if(NOT "${target_type}" STREQUAL "EXECUTABLE")
		return()
	endif()

    set(link_options
        -Wl,--gc-sections)

    target_link_options(${target_name} PRIVATE ${link_options})
endfunction()

# endregion






function(target_add_toolchain_options target_name)
	target_add_compile_options(${target_name})
	target_add_link_options_when_it_is_exe(${target_name})
endfunction()
