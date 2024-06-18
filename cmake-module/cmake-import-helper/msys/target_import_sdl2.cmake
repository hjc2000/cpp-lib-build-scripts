function(target_import_sdl2 target_name visibility)
    target_include_directories(${target_name} ${visibility} ${libs_path}/sdl2/include/SDL2)
    target_auto_link_lib(${target_name} SDL2 ${libs_path}/sdl2/lib/)
    install_dll_dir(${libs_path}/sdl2/bin/)

    # 一旦使用了 SDL2 库，不定义这个宏的话，main 函数会被替换掉
    # 这里需要设置为 PUBLIC 保证这个预定义能够沿着依赖链传递，否则依赖链中每个环节都要自己预定义
    target_compile_definitions(${target_name} ${visibility} SDL_MAIN_HANDLED)
endfunction()
