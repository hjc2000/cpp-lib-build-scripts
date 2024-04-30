$c_cxx_flags = " -Wall -Wextra -Wno-unused-parameter " +
" -mcpu=cortex-m3 -mthumb " +
" -fno-strict-aliasing -ffunction-sections -fdata-sections " +
" --specs=nano.specs "

$asm_flags = "${c_cxx_flags} -x assembler-with-cpp "

$exe_link_flags = " -T${build_script_path}/link-script/STM32F103ZETX_FLASH.ld " +
" --specs=nosys.specs " +
" -Wl,-Map=out_map.map " +
" -Wl,--gc-sections " +
" -static "
