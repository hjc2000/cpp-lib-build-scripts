function(target_add_platform_toolchain_options target_name)
	# region 编译器和链接器都要添加的选项
    set(options
		--target=arm-none-eabi
        -mcpu=cortex-m7
		-mthumb
        -mfloat-abi=hard
		-mfpu=fpv5-sp-d16
        -nodefaultlibs
		-finline-limit=100
    )

	target_compile_options(${target_name} PUBLIC ${options})
	target_link_options(${target_name} PUBLIC ${options})
	# endregion

	# region 添加库和头文件
    set(options
		"-I$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/arm-none-eabi/include"
		"-I$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/arm-none-eabi/include/c++/14.2.1"
		"-I$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/lib/gcc/arm-none-eabi/14.2.1/include"
		"-I$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/lib/gcc/arm-none-eabi/14.2.1/include-fixed"

		"-L$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/arm-none-eabi/lib"
		"-L$ENV{cpp_lib_build_scripts_path}/.toolchain/arm-none-eabi-14.2/lib/gcc/arm-none-eabi/14.2.1"

		-lc        # newlib libc
		-lm        # newlib libm (math)
		-lgcc      # GCC runtime support (e.g. integer division, atomic ops)
		-lstdc++   # C++ standard library
		-lunwind   # for C++ exception unwinding
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

	# region 链接选项
	set(options
		-flavor gnu
	)

	target_link_options(${target_name} PUBLIC ${options})
	# endregion

	# region 添加 lto
	set(options
		-flto=auto
	)

	target_compile_options(${target_name} PUBLIC ${options})
	target_link_options(${target_name} PUBLIC ${options})
	# endregion

	# region 所有语言都要添加的编译选项
	set(options
        -fno-strict-aliasing
        -ffunction-sections
        -fdata-sections
		-fmessage-length=0
	)

    target_compile_options(${target_name} PUBLIC ${options})
	# endregion

	# region 警告选项
    set(options
		-Wall
		-Wextra
		-Wno-unused-parameter
    )

    target_compile_options(${target_name} PUBLIC ${options})
	# endregion

	# region C++ 编译选项
    set(options
		-fexceptions
		-fno-rtti
		-funwind-tables
	)

    target_compile_options(${target_name} PUBLIC $<$<COMPILE_LANGUAGE:CXX>:${options}>)
	# endregion

	# region 汇编选项
    set(options
        -x assembler-with-cpp
    )

    target_compile_options(${target_name} PUBLIC $<$<COMPILE_LANGUAGE:ASM>:${options}>)
	# endregion

	# region 是可执行文件时才要添加的链接选项
    get_target_property(target_type ${target_name} TYPE)

	if("${target_type}" STREQUAL "EXECUTABLE")
		set(options
			-Wl,--gc-sections
			-Wl,-Map=out_map.map,--cref
			-static
		)

		target_link_options(${target_name} PUBLIC ${options})

		# 检查链接脚本文件是否存在
		if(EXISTS "${CMAKE_SOURCE_DIR}/link_script.ld")
			# 文件存在，添加 -T 选项及链接脚本路径
			target_link_options(${target_name} PUBLIC -T${CMAKE_SOURCE_DIR}/link_script.ld)
		endif()
	endif()
	# endregion
endfunction()
