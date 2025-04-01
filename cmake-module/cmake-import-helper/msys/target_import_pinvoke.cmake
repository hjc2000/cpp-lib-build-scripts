include(target_import_base)

function(target_import_pinvoke target_name visibility)
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/pinvoke/include/)
    target_auto_link_lib(${target_name} pinvoke $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/pinvoke/lib/)

	target_import_base(${target_name} ${visibility})
endfunction()
