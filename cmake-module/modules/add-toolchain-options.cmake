# region target_add_compile_options

# 添加所有平台通用的编译器选项。
function(target_add_compile_options target_name)
    # 定义汇编器相关的编译选项
    set(asm_flags
        -x assembler-with-cpp
    )

    # 为汇编源文件追加额外的编译选项
    target_compile_options(${target_name} PRIVATE $<$<COMPILE_LANGUAGE:ASM>:${asm_flags}>)
endfunction()

# endregion










function(target_add_toolchain_options target_name)
	target_add_compile_options(${target_name})
endfunction()
