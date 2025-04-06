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




# 安装一个项目目标编译产生的 obj 文件目录
function(target_install_obj_dir target_name)
	#
	# ss安装前删除旧的 obj 目录，防止源文件重命名或删除后旧的 obj 文件还存在。
	#
	# 有空设计一个命令，接收源文件路径，接收目标文件路径，然后将目标文件路径安装到
	# 安装目录的 obj 目录下。安装过程中检查 obj 是否有对应的源文件，有才实际拷贝
	# 过去。
	#
	# 安装前删除安装目录的 obj 目录的操作也放到该命令中。
	#
	install(CODE "
		execute_process(
			COMMAND try-remove-items.exe --paths \"${CMAKE_INSTALL_PREFIX}/obj\"
			WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
			OUTPUT_VARIABLE std_out
			RESULT_VARIABLE exit_code
		)

		message(STATUS \"\${std_out}\")
	")

	install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${target_name}.dir/"
			DESTINATION "${CMAKE_INSTALL_PREFIX}/obj"
			# 安装时保留原始的权限
			USE_SOURCE_PERMISSIONS
			FILES_MATCHING
			PATTERN "*.o"
			PATTERN "*.obj")
endfunction(target_install_obj_dir )




function(target_install target_name)
	install(TARGETS ${target_name}
			RUNTIME DESTINATION bin
			LIBRARY DESTINATION lib
			ARCHIVE DESTINATION lib)
endfunction(target_install target_name)


function(target_total_install target_name)
	install(TARGETS ${target_name}
			RUNTIME DESTINATION ${total_install_path}/bin
			LIBRARY DESTINATION ${total_install_path}/lib
			ARCHIVE DESTINATION ${total_install_path}/lib)
endfunction(target_total_install target_name)


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
