# 编译，链接选项
# 则需要在任何一个 project 函数的调用之前调用，否则 cmake 会报错，
# 说编译器无法编译测试程序。
string(
	CONCAT C_CXX_FLAGS
	" -Wall -Wextra -Wno-unused-parameter "
	" -mcpu=cortex-m3 -mthumb "
	" -fno-strict-aliasing -ffunction-sections -fdata-sections "
	" -fexceptions "
)
set(CMAKE_C_FLAGS ${C_CXX_FLAGS})
set(CMAKE_CXX_FLAGS ${C_CXX_FLAGS})

set(CMAKE_ASM_FLAGS "${C_CXX_FLAGS} -x assembler-with-cpp")

# 特定于可执行文件的链接选项
string(
	CONCAT CMAKE_EXE_LINKER_FLAGS
	" -Wl,-Map=out_map.map "
	" -Wl,--gc-sections "
	" -static "
)
# 检查链接脚本文件是否存在
if(EXISTS "${CMAKE_SOURCE_DIR}/link_script.ld")
	# 文件存在，添加 -T 选项及链接脚本路径到 CMAKE_EXE_LINKER_FLAGS
	string(
		APPEND CMAKE_EXE_LINKER_FLAGS
		" -T${CMAKE_SOURCE_DIR}/link_script.ld "
	)
endif()

set(CMAKE_EXECUTABLE_SUFFIX ".elf")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
