function(target_import_boost target_name visibility)
	target_include_directories(
		${target_name}
		${visibility}
		$ENV{cpp_lib_build_scripts_path}/${platform}/.libs/boost/include
	)
endfunction()
