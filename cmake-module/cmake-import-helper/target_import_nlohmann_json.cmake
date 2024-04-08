function(target_import_nlohmann_json target_name)
    target_include_directories(${target_name} PUBLIC ${libs_path}/nlohmann-json/include/)
endfunction()