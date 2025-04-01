function(target_import_nlohmann_json target_name visibility)
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/nlohmann-json/include/)
endfunction()
