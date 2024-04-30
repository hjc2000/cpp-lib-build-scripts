function(target_import_nlohmann_json target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/nlohmann-json/include/)
endfunction()