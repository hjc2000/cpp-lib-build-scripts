function(target_import_libstm32f103_hal target_name visibility)
    target_include_directories(
        ${target_name}
        ${visibility}
        ${libs_path}/target_import_libstm32f103_hal/include
    )

    target_link_libraries(
        ${target_name}
        ${visibility}
        ${libs_path}/libstm32f103-hal/lib/libstm32f103-hal.a
    )

    install(
        FILES ${libs_path}/libstm32f103-hal/lib/libstm32f103-hal.a
        DESTINATION lib
    )
endfunction()
