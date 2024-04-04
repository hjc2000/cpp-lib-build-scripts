if(MSVC)
    add_compile_options(/Zc:__cplusplus)
endif()

function(target_import_qt_core target_name)
    add_and_install_third_party_include_dir(${target_name} ${libs_path}/qt5/include)
    target_auto_link_lib(${target_name} Qt6Core ${libs_path}/qt5/lib)
    install_one_file(${libs_path}/qt5/bin/Qt6Core.dll bin)
endfunction()
