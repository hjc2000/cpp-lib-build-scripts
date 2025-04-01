function(target_import_boost target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/boost/include/)

    if(WIN32)
        # 定义 windows API 版本
        target_compile_definitions(${target_name} ${visibility} -D_WIN32_WINNT=0x0A00)
    endif()
endfunction()





function(target_import_boost_asio target_name visibility)
	target_import_boost(${target_name} ${visibility})

    if(WIN32)
        target_link_libraries(${target_name} ${visibility} ws2_32)
    endif()
endfunction()
