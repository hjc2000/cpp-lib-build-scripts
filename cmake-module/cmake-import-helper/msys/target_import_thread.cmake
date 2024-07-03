include(target_import_base)

function(target_import_thread target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/thread/include/)
    target_auto_link_lib(${target_name} thread ${libs_path}/thread/lib/)
    install_dll_dir(${libs_path}/thread/bin/)

	target_import_base(${target_name} ${visibility})
endfunction()
