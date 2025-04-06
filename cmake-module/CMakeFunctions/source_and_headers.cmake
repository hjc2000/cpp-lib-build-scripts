# region target_add_header_files_recurse

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

# endregion


# region target_add_source_files_recurse

# 递归收集 ${source_path} 下的所有源文件，添加到目标 ${target_name} 中。
function(target_add_source_files_recurse target_name source_path)
	get_target_property(target_type ${target_name} TYPE)

	# 判断项目类型是否为可执行文件
	if("${target_type}" STREQUAL "EXECUTABLE")
		# 如果是可执行文件，收集所有指定的源文件，包括 .obj 文件
		file(GLOB_RECURSE source_file_list
			"${source_path}/*.c"
			"${source_path}/*.cpp"
			"${source_path}/*.s"
			"${source_path}/*.o"
			"${source_path}/*.obj")
	else()
		# 如果不是可执行文件，不收集 .obj 文件
		file(GLOB_RECURSE source_file_list
			"${source_path}/*.c"
			"${source_path}/*.cpp"
			"${source_path}/*.s")
	endif()

	target_sources(${target_name} PRIVATE ${source_file_list})
endfunction()

# endregion


# region target_add_pch

# 添加预编译标头。
function(target_add_pch target_name)
	set(pch_path "${CMAKE_CURRENT_SOURCE_DIR}/private_src/pch.h")

	# 如果预编译标头存在则添加
	if(EXISTS "${pch_path}")
		target_precompile_headers(${target_name} PRIVATE "${pch_path}")
		message(STATUS "预编译标头已启用: ${pch_path}")
	endif()
endfunction(target_add_pch target_name)

# endregion


# region target_import_src_root_path

# 导入 root_path 中的源码。
# root_path 中的源码按照标准的目录结构存放。
function(target_import_src_root_path target_name root_path)
	if(EXISTS ${root_path}/src/)
		target_add_source_files_recurse(${target_name} ${root_path}/src/)
		target_add_header_files_recurse(${target_name} PUBLIC ${root_path}/src/)
		install_header_files_recurse(${root_path}/src/)
	endif()

	# 放到项目根目录的 include 目录中的头文件会被包含，然后安装时保持目录结构安装。
	if(EXISTS ${root_path}/include/)
		target_include_directories(${target_name} PUBLIC ${root_path}/include/)
		install_include_dir(${root_path}/include)
		target_add_source_files_recurse(${target_name} ${root_path}/include/)
	endif()

	# 导入 private_src 中的头文件和源码。
	# private_src 中的头文件是私有的，不会被安装，同时是通过 PRIVATE 添加到包含的。
	# 这可以用来放置内部私有的代码，实现类似 C# 中的 internal 修饰符的效果。
	if(EXISTS ${root_path}/private_src/)
		target_add_header_files_recurse(${target_name} PRIVATE ${root_path}/private_src/)
		target_add_source_files_recurse(${target_name} ${root_path}/private_src/)
		target_add_pch(${target_name})
	endif()

	if(EXISTS ${root_path}/private_include/)
		target_include_directories(${target_name} PRIVATE ${root_path}/private_include/)
		target_add_source_files_recurse(${target_name} ${root_path}/private_include/)
	endif()

	# 将本目标的编译产物安装到标准目录
	target_install(${target_name})
	target_total_install(${target_name})
endfunction()

# endregion


# region target_import_src

# 导入 ${CMAKE_CURRENT_SOURCE_DIR} 中的源码。
# ${CMAKE_CURRENT_SOURCE_DIR} 中的源码按照标准的目录结构存放。
function(target_import_src target_name)
	target_import_src_root_path(${target_name} "${CMAKE_CURRENT_SOURCE_DIR}/")
endfunction()

# endregion
