function(target_add_platform_toolchain_options target_name)
	# region 编译器和链接器都要加的选项
	set(options
		-flto=auto
    )

	target_compile_options(${target_name} PRIVATE ${options})
	target_link_options(${target_name} PRIVATE ${options})
	# endregion
endfunction()
