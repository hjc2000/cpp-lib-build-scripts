cmake_minimum_required(VERSION 3.20)
cmake_policy(SET CMP0177 NEW)

if(1)
	get_filename_component(CURRENT_DIR_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
	set(ProjectName "${CURRENT_DIR_NAME}")

	include($ENV{cpp_lib_build_scripts_path}/cmake-module/setup.cmake)

	project(${ProjectName})
	enable_language(ASM)
	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_C_STANDARD 17)
endif()

include("./project.cmake")
