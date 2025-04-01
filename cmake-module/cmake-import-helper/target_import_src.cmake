# 导入项目文件夹中的 src 文件夹内的源文件和头文件
function(target_import_src target_name)
	target_import_src_root_path(${target_name} "${CMAKE_CURRENT_SOURCE_DIR}/")
endfunction()
