# 导入项目文件夹中的 src 文件夹内的源文件和头文件
function(target_import_src target_name)
    target_add_source_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/src/)
    add_and_install_headers_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/src/)
    install_target_to_standard_paths(${target_name})

    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include/)
        # 放到项目根目录的 include 目录中的头文件会被包含，然后安装时保持目录结构安装。
        target_include_directories(${target_name} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/)
        install_dir(${CMAKE_CURRENT_SOURCE_DIR}/include include "*")
        target_add_source_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/include/)
    endif()
endfunction()
