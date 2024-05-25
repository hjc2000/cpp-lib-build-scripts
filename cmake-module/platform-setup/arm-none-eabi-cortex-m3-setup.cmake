# 编译，链接选项
# 则需要在任何一个 project 函数的调用之前调用，否则 cmake 会报错，
# 说编译器无法编译测试程序。
if(1)
	string(
		CONCAT C_CXX_FLAGS
		" -Wall -Wextra -Wno-unused-parameter "
		" -mcpu=cortex-m3 -mthumb "
		" -fno-strict-aliasing -ffunction-sections -fdata-sections "
		" --specs=nano.specs "
	)
	set(CMAKE_C_FLAGS ${C_CXX_FLAGS})
	set(CMAKE_CXX_FLAGS ${C_CXX_FLAGS})

	set(CMAKE_ASM_FLAGS "${C_CXX_FLAGS} -x assembler-with-cpp")

	string(
		CONCAT CMAKE_EXE_LINKER_FLAGS
		" -T${CMAKE_SOURCE_DIR}/link_script.ld "
		" --specs=nosys.specs "
		" -Wl,-Map=out_map.map "
		" -Wl,--gc-sections "
		" -static "
	)

	set (CMAKE_EXECUTABLE_SUFFIX ".elf" CACHE STRING "可执行文件后缀名")
	set (CMAKE_STATIC_LIBRARY_SUFFIX ".a" CACHE STRING "静态库文件后缀名")
endif()
