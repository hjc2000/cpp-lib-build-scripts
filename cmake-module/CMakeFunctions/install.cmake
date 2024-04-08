# 将 ${target_name} 目标编译产生的 .a, .lib, .so, .dll, .exe 等文件
# 安装到标准的路径。
#
# 标准路径即安装路径下的 include, lib, bin 这 3 个目录。
function(install_target_to_standard_paths target_name)
    install(
        TARGETS ${target_name}
        RUNTIME DESTINATION bin # 可执行文件和DLL到 bin
        LIBRARY DESTINATION lib # 共享库 (.so) 到 lib
        ARCHIVE DESTINATION lib
    )
endfunction()





# 将 ${src_dir} 目录的内容安装到 ${dst_dir} 目录下。会保持目录结构。
# ${pattern} 是通配符，例如 "*" 匹配所有，"*.h" 匹配所有头文件。
function(install_dir src_dir dst_dir pattern)
    install(
        DIRECTORY ${src_dir}/
        DESTINATION ${dst_dir}
        # 安装时保留原始的权限
        USE_SOURCE_PERMISSIONS
        FILES_MATCHING
        # 使用提供的模式，或默认匹配所有文件
        PATTERN ${pattern}
    )
endfunction()





# 将 dll_dir 下的所有 dll 安装到 ${CMAKE_INSTALL_PREFIX}/bin
# 因为是按文件夹安装，只不过是加了 *.dll 的筛选器，所以会保持原来的目录结构
#
# 参数：
#   dll_dir - 要被安装的 dll 所在的目录
function(install_dll_dir dll_dir)
    install_dir(${dll_dir}/ bin "*.dll")
endfunction()


# 安装一个文件到指定的路径。
#
# 参数：
#   file_path - 要被安装的文件的路径
#   dest_dir - 要将此文件安装到的文件夹。此文件夹相对于 CMAKE_INSTALL_PREFIX。
function(install_one_file file_path dest_dir)
    install(FILES "${file_path}" DESTINATION "${dest_dir}")
endfunction()


# 将一个文件夹中的头文件安装到安装目录下的 include 目录。
# 会保持目录结构，同时会过滤，仅安装 *.h
function(install_include_dir include_dir)
    if(${option_install_headers})
        install_dir(${include_dir} include "*.h")
    endif()
endfunction()
