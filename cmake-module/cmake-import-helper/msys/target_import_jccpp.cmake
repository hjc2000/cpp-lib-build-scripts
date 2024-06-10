include(target_import_base)

function(target_import_jccpp target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/jccpp/include/)
    target_auto_link_lib(${target_name} jccpp ${libs_path}/jccpp/lib/)
    install_dll_dir(${libs_path}/jccpp/bin/)

	target_import_base(${target_name} ${visibility})
endfunction()
