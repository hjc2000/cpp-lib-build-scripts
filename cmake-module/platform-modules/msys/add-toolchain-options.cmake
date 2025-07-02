function(target_add_platform_toolchain_options target_name)
    set(options
		-flto=auto
    )

	target_compile_options(${target_name} PRIVATE ${options})
	target_link_options(${target_name} PRIVATE ${options})
endfunction()
