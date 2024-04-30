function(target_import_boost target_name)
    target_include_directories(${target_name} PUBLIC ${libs_path}/boost/include/)
endfunction()
