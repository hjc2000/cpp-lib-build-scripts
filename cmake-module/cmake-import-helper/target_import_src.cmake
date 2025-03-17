# 导入项目文件夹中的 src 文件夹内的源文件和头文件
function(target_import_src target_name)
	if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/)
		target_add_source_files_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/src/)
		target_add_header_files_recurse(${target_name} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src/)
		install_header_files_recurse(${CMAKE_CURRENT_SOURCE_DIR}/src/)
	endif()

	# 放到项目根目录的 include 目录中的头文件会被包含，然后安装时保持目录结构安装。
	if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/include/)
		target_include_directories(${target_name} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/)
		install_include_dir(${CMAKE_CURRENT_SOURCE_DIR}/include)
		target_add_source_files_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/include/)
	endif()

	# 导入 private_src 中的头文件和源码。
	# private_src 中的头文件是私有的，不会被安装，同时是通过 PRIVATE 添加到包含的。
	# 这可以用来放置内部私有的代码，实现类似 C# 中的 internal 修饰符的效果。
	if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/private_src/)
		target_add_header_files_recurse(${target_name} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/private_src/)
		target_add_source_files_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/private_src/)
		target_add_pch(${target_name})
	endif()

	if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/private_include/)
		target_include_directories(${target_name} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/private_include/)
		target_add_source_files_recurse(${target_name} ${CMAKE_CURRENT_SOURCE_DIR}/private_include/)
	endif()

	# 将本目标的编译产物安装到标准目录
	target_install(${target_name})
	target_total_install(${target_name})
endfunction()
