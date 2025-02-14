set(has_thread TRUE)

list(PREPEND CMAKE_PREFIX_PATH $ENV{cpp_lib_build_scripts_path}/${platform}/.total-install)
list(PREPEND CMAKE_PREFIX_PATH $ENV{cpp_lib_build_scripts_path}/${platform}/.total-install/lib)
list(APPEND CMAKE_PREFIX_PATH "C:/msys64/ucrt64/lib")
list(APPEND CMAKE_PREFIX_PATH "C:/msys64/ucrt64")
message(STATUS "CMAKE_PREFIX_PATH 的值：${CMAKE_PREFIX_PATH}")
