if [ -z "$libs_path" ]; then
	echo "未发现环境变量 libs_path"
	exit 1
fi

if [ -z "$repos_path" ]; then
	echo "未发现环境变量 repos_path"
	exit 1
fi

if [ -z "$cpp_lib_build_scripts_path" ]; then
	echo "未发现环境变量 cpp_lib_build_scripts_path"
	exit 1
fi