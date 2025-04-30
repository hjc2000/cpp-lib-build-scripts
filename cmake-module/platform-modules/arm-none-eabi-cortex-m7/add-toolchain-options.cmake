function(target_add_platform_compile_and_link_options target_name)
    set(options
        -mcpu=cortex-m7
		-mthumb
        -mfloat-abi=hard
		-mfpu=fpv5-sp-d16
        -nodefaultlibs
		-finline-limit=100
    )

	target_compile_options(${target_name} PRIVATE ${options})
	target_link_options(${target_name} PRIVATE ${options})
endfunction()




function(target_add_platform_compile_options target_name)
    set(options
		-fexceptions
		-fno-rtti)

    target_compile_options(${target_name} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${options}>)
endfunction()





# region target_add_platform_link_options_when_it_is_exe

function(target_add_platform_link_options_when_it_is_exe target_name)
    get_target_property(target_type ${target_name} TYPE)
	if(NOT "${target_type}" STREQUAL "EXECUTABLE")
		return()
	endif()

    set(link_options
		-Wl,-Map=out_map.map,--cref
        -static)

    target_link_options(${target_name} PRIVATE ${link_options})

    # 检查链接脚本文件是否存在
    if(EXISTS "${CMAKE_SOURCE_DIR}/link_script.ld")
        # 文件存在，添加 -T 选项及链接脚本路径
        target_link_options(${target_name} PRIVATE -T${CMAKE_SOURCE_DIR}/link_script.ld)
    endif()
endfunction()

# endregion





function(target_add_platform_toolchain_options target_name)
	target_add_platform_compile_and_link_options(${target_name})
	target_add_platform_compile_options(${target_name})
	target_add_platform_link_options_when_it_is_exe(${target_name})
endfunction()
