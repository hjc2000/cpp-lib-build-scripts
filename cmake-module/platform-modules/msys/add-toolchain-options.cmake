function(target_add_platform_toolchain_options target_name)
	# region 编译器和链接器都要加的选项
	set(options
		-flto=auto
    )

	target_compile_options(${target_name} PRIVATE ${options})
	target_link_options(${target_name} PRIVATE ${options})
	# endregion

	# region C, C++ 都要添加的编译选项
	set(options
        -Wall -Wextra -Wno-unused-parameter
        -fno-strict-aliasing
        -ffunction-sections
        -fdata-sections
		-fmessage-length=0
	)

    target_compile_options(${target_name} PRIVATE ${c_cpp_flags})
	# endregion

	# region 是 可执行文件时添加的链接选项
	set(link_options
        -Wl,--gc-sections)

	get_target_property(target_type ${target_name} TYPE)

	if("${target_type}" STREQUAL "EXECUTABLE")
		target_link_options(${target_name} PRIVATE ${link_options})
	endif()
	# endregion

endfunction()
