~/ricv_newlib_toolchain/bin/riscv64-unknown-elf-gcc -Wall -march=rv64g -mabi=lp64d -T ../custom.ld -O2 -Isimple -I. -DFLAGS_STR=\""-O2   "\" -DITERATIONS=0  core_list_join.c core_main.c core_matrix.c core_state.c core_util.c simple/core_portme.c -o ./coremark.elf \
~/ricv_newlib_toolchain/bin/riscv64-unknown-elf-objcopy --only-section=.text -O binary -S coremark.elf coremark.text.bin \
hexdump -ve '1/4 "%08x\n"' coremark.text.bin > coremark.text.hex \
~/ricv_newlib_toolchain/bin/riscv64-unknown-elf-objcopy --remove-section=.text -O binary -S coremark.elf coremark.data.bin \
hexdump -ve '1/4 "%08x\n"' coremark.data.bin > coremark.data.hex \
~/ricv_newlib_toolchain/bin/riscv64-unknown-elf-objdump -S coremark.elf > coremark.elf.txt