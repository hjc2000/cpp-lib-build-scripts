function(target_import_libusb target_name visibility)
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/libusb/include/)
    target_auto_link_lib(${target_name} libusb-1.0 $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/libusb/lib/)
endfunction()
