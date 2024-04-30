function(target_import_boost target_name)
    target_include_directories(${target_name} PUBLIC ${libs_path}/boost/include/)

    if(WIN32)
        # 定义 windows API 版本
        target_compile_definitions(${target_name} PRIVATE -D_WIN32_WINNT=0x0A00)
    endif()
endfunction()





function(target_import_boost_asio target_name)
	target_import_boost(${target_name})

    if(WIN32)
        target_link_libraries(${target_name} PUBLIC ws2_32)
    endif()
endfunction()
