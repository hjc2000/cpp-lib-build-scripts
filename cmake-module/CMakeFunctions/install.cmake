# 将 ${src_dir} 目录的内容安装到 ${dst_dir} 目录下。会保持目录结构。
# ${pattern} 是通配符，例如 "*" 匹配所有，"*.h" 匹配所有头文件。
function(install_dir src_dir dst_dir pattern)
    install(DIRECTORY ${src_dir}/
        	DESTINATION ${dst_dir}
			# 安装时保留原始的权限
			USE_SOURCE_PERMISSIONS
			# 使用提供的模式，或默认匹配所有文件
        	FILES_MATCHING
			PATTERN ${pattern})
endfunction()






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
