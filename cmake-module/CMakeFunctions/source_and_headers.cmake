# 递归遍历 ${header_dir}，收集其中的头文件，然后获取他们所在的目录，
# 将这些目录添加到 ${target} 的包含目录，并且是以 PRIVATE 的方式。
function(add_private_headers_recurse target header_dir)
    append_header_file_paths_to_list_recurse(${header_dir} header_path_list)

    # 将收集到的目录添加到目标的包含目录中
    target_include_directories(${target} PRIVATE ${header_path_list})
endfunction()





# 递归收集头文件，添加到查找路径，然后定义安装规则，安装时会将这些头文件
# 都安装到 include 目录下。
function(add_and_install_headers_recurse target src_dir)
    # 收集指定目录及其子目录下所有的头文件
    file(GLOB_RECURSE HEADERS "${src_dir}/*.h")

    # 获取所有头文件的目录并去重，以添加到编译时的包含目录中
    set(DIRS "")
    foreach(HEADER ${HEADERS})
        get_filename_component(DIR ${HEADER} DIRECTORY)
        list(APPEND DIRS ${DIR})
    endforeach()
    list(REMOVE_DUPLICATES DIRS)

    # 将收集到的目录添加到目标的编译时包含目录中
    target_include_directories(${target} PUBLIC ${DIRS})

    # 安装所有收集到的头文件到安装前缀的include目录下
    if(${option_install_headers})
        install(FILES ${HEADERS} DESTINATION include)
    endif()
endfunction()




# 递归访问 source_path，收集所有源文件，然后添加到目标中
function(target_add_source_recurse target_name source_path)
    append_source_files_to_list_recurse(${source_path}/ source_files)
    target_sources(${target_name} PRIVATE ${source_files})
endfunction()
