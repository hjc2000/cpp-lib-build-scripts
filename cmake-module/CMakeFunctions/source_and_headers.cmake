# 递归收集头文件，添加到查找路径，然后定义安装规则，安装时会将这些头文件
# 都安装到 include 目录下。
function(target_add_header_files_recurse target visibility src_dir)
	execute_process(
		COMMAND collect-header-file-dir-recurse --paths "./"
		WORKING_DIRECTORY ${src_dir}
		OUTPUT_VARIABLE header_file_path_list
		RESULT_VARIABLE exit_code
	)

	if(exit_code EQUAL 0)
		# 无操作
	else()
		message(FATAL_ERROR "递归收集 ${src_dir} 中的头文件失败。")
	endif()

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



# 添加预编译标头。
function(target_add_pch target_name)
	set(pch_path "${CMAKE_CURRENT_SOURCE_DIR}/include/${target_name}/pch.h")

	# 如果预编译标头存在则添加
	if(EXISTS "${pch_path}")
		target_precompile_headers(${target_name} PUBLIC "${pch_path}")
		message(STATUS "预编译标头已启用: ${pch_path}")
	endif()
endfunction(target_add_pch target_name)
