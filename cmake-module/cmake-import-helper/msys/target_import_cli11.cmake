function(target_import_cli11 target_name visibility)
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/cli11/include/)
endfunction()
