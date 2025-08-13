# 编译目标
add_library(${ProjectName} STATIC)
target_import_src(${ProjectName})



# 添加测试程序
if(("${platform}" STREQUAL "msys") OR
   ("${platform}" STREQUAL "msys-clang"))
	set(test_exe_target_name "test")
	add_executable(${test_exe_target_name})
	target_import_test(${test_exe_target_name})

	target_import_base(${test_exe_target_name} PUBLIC)
	target_link_libraries(${test_exe_target_name} PUBLIC "${ProjectName}")
endif()
