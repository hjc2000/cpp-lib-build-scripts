# 递归收集头文件，添加到查找路径，然后定义安装规则，安装时会将这些头文件
# 都安装到 include 目录下。
function(add_header_files_recurse target visibility src_dir)
    append_header_file_paths_to_list_recurse(${src_dir} header_file_path_list)
    target_include_directories(${target} ${visibility} ${header_file_path_list})
endfunction()






# 递归收集 ${source_path} 下的所有源文件，添加到目标 ${target_name} 中。
function(target_add_source_files_recurse target_name source_path)
    append_source_files_to_list_recurse(${source_path}/ source_file_list)
    target_sources(${target_name} PRIVATE ${source_file_list})
endfunction()
