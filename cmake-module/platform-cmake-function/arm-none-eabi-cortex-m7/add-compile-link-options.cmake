function(target_add_platform_link_options target_name)
    set(link_options
        -Wl,-Map=out_map.map
        -Wl,--gc-sections
        -static
    )

    # 为目标添加通用的链接选项
    target_link_options(${target_name} PRIVATE ${link_options})

    # 检查链接脚本文件是否存在
    if(EXISTS "${CMAKE_SOURCE_DIR}/link_script.ld")
        # 文件存在，添加 -T 选项及链接脚本路径
        target_link_options(${target_name} PRIVATE -T${CMAKE_SOURCE_DIR}/link_script.ld)
    endif()
endfunction()
