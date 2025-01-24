function(target_import_libusb target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/libusb/include/)
    target_auto_link_lib(${target_name} libusb-1.0 ${libs_path}/libusb/lib/)
endfunction()
