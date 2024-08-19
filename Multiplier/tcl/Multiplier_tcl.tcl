quit -sim
.main clear
set PrefMain(saveLines) 10000000
cd C:/Users/asus/Desktop/FPGA_Modelsim/Sim
cmd /c "if exist work rmdir /S /Q work"
vlib work
vmap work
vcom -2008 ../Source/*.vhd
vcom -2008 ../test/*.vhd
vsim -t 100 ps  -vopt PacketChecker_tb -voptargs=+acc
add wave -format logic -radix decimal sim:/Multiplier_tb/*
add wave -format logic -radix decimal sim:/Multiplier_tb/uut/*
run -all
















# do C:/Users/asus/Desktop/FPGA_Modelsim/tcl/PacketChecker_tcl.tcl