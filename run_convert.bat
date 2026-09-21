@echo off
g++ .\Compile\convert.cpp -static -o .\Compile\convert.exe
echo Compiling RISC-V...

D:\risc-v-toolchain\xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-gcc.exe ^
-march=rv32i ^
-mabi=ilp32 ^
-nostdlib ^
-Ttext=0x0 ^
.\testr.s ^
-o .\Compile\program.elf

echo Generating raw mem...

D:\risc-v-toolchain\xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-objcopy.exe ^
-O verilog ^
.\Compile\program.elf ^
.\Compile\raw.mem

echo Converting mem...
.\Compile\convert.exe
echo Done.
pause