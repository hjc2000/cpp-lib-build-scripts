# 递归收集头文件，添加到查找路径，然后定义安装规则，安装时会将这些头文件
# 都安装到 include 目录下。
function(target_add_header_files_recurse target visibility src_dir)
    append_header_file_paths_to_list_recurse(${src_dir} header_file_path_list)
    target_include_directories(${target} ${visibility} ${header_file_path_list})
endfunction()






# 递归收集 ${source_path} 下的所有源文件，添加到目标 ${target_name} 中。
function(target_add_source_files_recurse target_name source_path)
	execute_process(
		COMMAND expand-wildcard-for-cmake --paths "**.c" "**.cpp" "**.h" "**.hpp" "**.s"
		WORKING_DIRECTORY ${source_path}
		OUTPUT_VARIABLE source_file_list
		RESULT_VARIABLE exit_code
	)

	if(exit_code EQUAL 0)
		# 无操作
	else()
		message(FATAL_ERROR "递归收集 ${source_path} 中的源文件失败。")
	endif()

	target_sources(${target_name} PRIVATE ${source_file_list})
endfunction()
