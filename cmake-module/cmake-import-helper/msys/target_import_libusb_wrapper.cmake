include(target_import_libusb)
include(target_import_base)

function(target_import_libusb_wrapper target_name visibility)
    target_include_directories(${target_name} ${visibility} $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/libusb-wrapper/include/)
    target_auto_link_lib(${target_name} libusb-wrapper $ENV{cpp_lib_build_scripts_path}/${platform}/.libs/libusb-wrapper/lib/)

	target_import_libusb(${target_name} ${visibility})
	target_import_base(${target_name} ${visibility})
endfunction()
