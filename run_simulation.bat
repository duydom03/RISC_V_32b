@echo off

echo Running simulation...

iverilog -o ./wave/cpu.vvp tb_riscv.v cpu_core.v ALU.v Control_Unit.v regfile.v imem.v dmem.v datapath.v ImmGen.v pc.v

vvp ./wave/cpu.vvp 

gtkwave ./wave/dump.vcd 
echo Done.
pause