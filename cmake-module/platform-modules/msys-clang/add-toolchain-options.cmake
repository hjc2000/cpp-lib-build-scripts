function(target_add_platform_toolchain_options target_name)
	# region 添加 lto
	set(options
		-flto=auto
	)

	target_compile_options(${target_name} PUBLIC ${options})
	target_link_options(${target_name} PUBLIC ${options})
	# endregion

	# region 使用 lld
	set(options
		-fuse-ld=lld
	)

	target_compile_options(${target_name} PUBLIC ${options})
	target_link_options(${target_name} PUBLIC ${options})
	# endregion

	# region 所有语言都要添加的编译选项
	set(options
        -Wall -Wextra -Wno-unused-parameter
        -fno-strict-aliasing
        -ffunction-sections
        -fdata-sections
		-fmessage-length=0
	)

    target_compile_options(${target_name} PUBLIC ${options})
	# endregion

	# region 汇编选项
    set(options
        -x assembler-with-cpp
    )

    target_compile_options(${target_name} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:${options}>)
	# endregion

	# region C++ 编译选项
    set(options
        -Wno-delete-non-abstract-non-virtual-dtor
    )

    target_compile_options(${target_name} PUBLIC $<$<COMPILE_LANGUAGE:CXX>:${options}>)
	# endregion

	# region 是可执行文件时添加的链接选项
	get_target_property(target_type ${target_name} TYPE)

	if("${target_type}" STREQUAL "EXECUTABLE")
		set(options
			-Wl,--gc-sections
		)

		target_link_options(${target_name} PUBLIC ${options})
	endif()
	# endregion
endfunction()
