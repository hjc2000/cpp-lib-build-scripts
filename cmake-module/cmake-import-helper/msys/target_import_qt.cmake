if(MSVC)
    add_compile_options(/Zc:__cplusplus)
endif()

function(target_import_qt_core target_name)
    target_include_directories(${target_name} PUBLIC ${libs_path}/qt5/include)
    target_auto_link_lib(${target_name} Qt6Core ${libs_path}/qt5/lib)
    install_one_file(${libs_path}/qt5/bin/Qt6Core.dll bin)
endfunction()
