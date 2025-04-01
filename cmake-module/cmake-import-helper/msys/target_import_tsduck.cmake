include(target_import_base)

function(target_import_tsduck target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/tsduck/include/)
    target_auto_link_lib(${target_name} tsduck ${libs_path}/tsduck/lib/)

	target_compile_definitions(${target_name} PRIVATE TS_NO_SRT=1)
	target_compile_definitions(${target_name} PRIVATE TS_NO_RIST=1)
	target_import_base(${target_name} ${visibility})
	target_link_libraries(${target_name} ${visibility} winmm Userenv Ws2_32)
endfunction()
