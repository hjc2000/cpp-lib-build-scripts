# 导入项目文件夹中的 src 文件夹内的源文件和头文件
function(target_import_src target_name)
    # src 目录中的所有头文件和源文件都是公共的。
    #
    # 会递归收集所有头文件，添加到包含，并且会安装，安装时不会保持目录结构，
    # 所有头文件都会被取出来安装到安装目录下的 include 目录。
    # 
    # 会递归收集所有源文件，添加到编译。
    target_add_source_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/src/)
    add_and_install_headers_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/src/)
    install_target_to_standard_paths(${target_name})

    # 放到项目根目录的 include 目录中的头文件会被包含，然后安装时保持目录结构安装。
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include/)
        target_include_directories(${target_name} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/)
        install_dir(${CMAKE_CURRENT_SOURCE_DIR}/include include "*")
        target_add_source_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/include/)
    endif()

    # 导入 private_src 中的头文件和源码。
    # private_src 中的头文件是私有的，不会被安装，同时是通过 PRIVATE 添加到包含的。
    # 这可以用来放置内部私有的代码，实现类似 C# 中的 internal 修饰符的效果。
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/private_src/)
        target_include_directories(${target_name} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/private_src/)
        target_add_source_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/private_src/)
    endif()
endfunction()
