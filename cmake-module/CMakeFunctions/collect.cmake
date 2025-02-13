# 递归遍历 ${path}，收集其中的头文件，然后分别获取它们所在的目录，
# 将这些目录添加到 ${out_list} 中。
function(append_header_file_paths_to_list_recurse path out_list)
    # 收集指定目录及其子目录下所有的头文件
    file(
        GLOB_RECURSE
        header_files
        "${path}/*.h"
        "${path}/*.hpp"
    )

    # 收集到的头文件目录放到这里
    set(header_dirs "")
    foreach(HEADER ${header_files})
        get_filename_component(DIR ${HEADER} DIRECTORY)
        list(APPEND header_dirs ${DIR})
    endforeach()

    list(REMOVE_DUPLICATES header_dirs)
    set(${out_list} ${header_dirs} PARENT_SCOPE)
endfunction()
