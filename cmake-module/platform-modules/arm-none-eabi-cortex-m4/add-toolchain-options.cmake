function(target_add_platform_toolchain_options target_name)
	# region 所有语言都要添加的编译选项
	set(options
        -Wall -Wextra -Wno-unused-parameter
        -fno-strict-aliasing
        -ffunction-sections
        -fdata-sections
		-fmessage-length=0
	)

    target_compile_options(${target_name} PRIVATE ${options})
	# endregion

	# region 编译器和链接器都要加的选项
	set(options
        -mcpu=cortex-m4
		-mthumb
        -mfloat-abi=hard
		-mfpu=fpv4-sp-d16
        -nodefaultlibs
		-finline-limit=100
    )

	target_compile_options(${target_name} PRIVATE ${options})
	target_link_options(${target_name} PRIVATE ${options})
	# endregion

	# region 如果是 Release 则添加 lto
	if(CMAKE_BUILD_TYPE STREQUAL "Release")
		set(options
			-flto=auto
			-ffat-lto-objects
		)

		target_compile_options(${target_name} PRIVATE ${options})
		target_link_options(${target_name} PRIVATE ${options})
	endif()
	# endregion

	# region C++ 编译选项
    set(options
		-fexceptions
		-fno-rtti)

    target_compile_options(${target_name} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${options}>)
	# endregion

	# region 汇编选项
    set(options
        -x assembler-with-cpp
    )

    target_compile_options(${target_name} PRIVATE $<$<COMPILE_LANGUAGE:ASM>:${options}>)
	# endregion

	# region 是可执行文件时才要添加的链接选项
    get_target_property(target_type ${target_name} TYPE)

	if("${target_type}" STREQUAL "EXECUTABLE")
		set(options
			-Wl,--gc-sections
			-Wl,-Map=out_map.map,--cref
			-static
		)

		target_link_options(${target_name} PRIVATE ${options})

		# 检查链接脚本文件是否存在
		if(EXISTS "${CMAKE_SOURCE_DIR}/link_script.ld")
			# 文件存在，添加 -T 选项及链接脚本路径
			target_link_options(${target_name} PRIVATE -T${CMAKE_SOURCE_DIR}/link_script.ld)
		endif()
	endif()
	# endregion
endfunction()
