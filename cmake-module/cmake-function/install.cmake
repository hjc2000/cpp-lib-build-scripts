# region install_include_dir

# 将一个文件夹中的头文件安装到安装目录下的 include 目录。
# 会保持目录结构，同时会过滤，仅安装 *.h
function(install_include_dir include_dir)
	install(DIRECTORY ${include_dir}/
			DESTINATION include
			FILES_MATCHING
			PATTERN "*.h"
			PERMISSIONS OWNER_READ GROUP_READ WORLD_READ
			PATTERN "*.hpp"
			PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)

	install(DIRECTORY ${include_dir}/
			DESTINATION ${total_install_path}/include
			FILES_MATCHING
			PATTERN "*.h"
			PERMISSIONS OWNER_READ GROUP_READ WORLD_READ
			PATTERN "*.hpp"
			PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)
endfunction()

# endregion


# region install_header_files_recurse

# 递归收集 ${header_dir} 下的所有头文件，安装到安装目录下的 include 目录。
function(install_header_files_recurse header_dir)
    # 收集指定目录及其子目录下所有的头文件
    file(GLOB_RECURSE header_files
		"${header_dir}/*.h"
		"${header_dir}/*.hpp")

    install(FILES ${header_files}
			DESTINATION include
			PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)

    install(FILES ${header_files}
			DESTINATION ${total_install_path}/include
			PERMISSIONS OWNER_READ GROUP_READ WORLD_READ)
endfunction()

# endregion


# region target_install_obj_dir

# 安装一个项目目标编译产生的 obj 文件目录
function(target_install_obj_dir target_name)
	# 对比 obj 路径和源文件路径，将没有对应源文件的垃圾 obj 删除。
	install(CODE "
		execute_process(
			COMMAND clean-garbage-obj --src_path \"${CMAKE_CURRENT_SOURCE_DIR}\" --obj_path \"${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target_name}.dir/\"
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
			OUTPUT_VARIABLE std_out
			RESULT_VARIABLE exit_code
		)

		# 检查子进程的退出码
		if(NOT \${exit_code} EQUAL 0)
			message(FATAL_ERROR \"clean-garbage-obj 命令执行失败: \${std_out}\")
		endif()

		message(STATUS \"\${std_out}\")
	")

	install(CODE "
		execute_process(
			COMMAND clean-garbage-obj --src_path \"${CMAKE_CURRENT_SOURCE_DIR}\" --obj_path \"${CMAKE_INSTALL_PREFIX}/obj\"
			WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
			OUTPUT_VARIABLE std_out
			RESULT_VARIABLE exit_code
		)

		# 检查子进程的退出码
		if(NOT \${exit_code} EQUAL 0)
			message(FATAL_ERROR \"clean-garbage-obj 命令执行失败: \${std_out}\")
		endif()

		message(STATUS \"\${std_out}\")
	")

	install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target_name}.dir/"
			DESTINATION "${CMAKE_INSTALL_PREFIX}/obj"
			# 安装时保留原始的权限
			USE_SOURCE_PERMISSIONS
			FILES_MATCHING
			PATTERN "*.o"
			PATTERN "*.obj")
endfunction(target_install_obj_dir)

# endregion


# region target_install

function(target_install target_name)
	install(TARGETS ${target_name}
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION lib
			ARCHIVE DESTINATION lib)
endfunction(target_install target_name)

# endregion


# region target_total_install

function(target_total_install target_name)
	install(TARGETS ${target_name}
			RUNTIME DESTINATION ${total_install_path}/bin
			LIBRARY DESTINATION ${total_install_path}/lib
			ARCHIVE DESTINATION ${total_install_path}/lib)
endfunction(target_total_install target_name)

# endregion


# region target_obj_size

function(target_obj_size target_name)
	file(GLOB obj_list
		"${CMAKE_CURRENT_BINARY_DIR}/${target_name}"
		"${CMAKE_CURRENT_BINARY_DIR}/${target_name}.exe"
		"${CMAKE_CURRENT_BINARY_DIR}/${target_name}.dll"
		"${CMAKE_CURRENT_BINARY_DIR}/lib${target_name}.dll"
		"${CMAKE_CURRENT_BINARY_DIR}/${target_name}.so"
		"${CMAKE_CURRENT_BINARY_DIR}/lib${target_name}.so"
		"${CMAKE_CURRENT_BINARY_DIR}/${target_name}.elf"
		"${CMAKE_CURRENT_BINARY_DIR}/lib${target_name}.elf"
	)

	foreach(obj ${obj_list})
		message(STATUS "-------------------------------------------------------------------\n")
		execute_process(COMMAND ${CMAKE_SIZE} "${obj}"
						WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
		message(STATUS "-------------------------------------------------------------------\n")
	endforeach(obj ${obj_list})

	add_custom_command(TARGET ${target_name} POST_BUILD
					COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${target_name}>)
endfunction(target_obj_size target_name)

# endregion
