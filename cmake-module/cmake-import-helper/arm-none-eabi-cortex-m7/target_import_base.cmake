include(target_import_boost)
include(target_import_nlohmann_json)

function(target_import_base target_name visibility)
	set(lib_name "base")

	if(has_thread)
		message(STATUS "此平台拥有线程")
		target_compile_definitions(${target_name} ${visibility} HAS_THREAD=1)
	else()
		message(STATUS "此平台没有线程")
	endif()

    target_include_directories(${target_name} ${visibility} ${libs_path}/${lib_name}/include/)
	target_add_pch(${target_name} "${libs_path}/${lib_name}/include/${lib_name}/pch.h")
    target_auto_link_lib(${target_name} ${lib_name} ${libs_path}/${lib_name}/lib/)

	target_import_boost(${target_name} ${visibility})
	target_import_nlohmann_json(${target_name} ${visibility})
endfunction()
