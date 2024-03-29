# CS 274
# Ursinus College
#
# @author: Michael Cummins
# @purpose: Localizing all compilations of components of the code

all:
	iverilog -o alu_tb.vvp alu_tb.v
	vvp alu_tb.vvp -vcd
	gtkwave alu_tb.vcd

	iverilog -o gen_reg_tb.vvp gen_reg_tb.v
	vvp gen_reg_tb.vvp -vcd
	gtkwave gen_reg_tb.vcd

	iverilog -o inc_reg_tb.vvp inc_reg_tb.v
	vvp inc_reg_tb.vvp -vcd
	gtkwave inc_reg_tb.vcd
	
	iverilog -o pointer_segment_regs_tb.vvp pointer_segment_regs_tb.v
	vvp pointer_segment_regs_tb.vvp -vcd
	gtkwave pointer_segment_regs_tb.vcd
	
alu:
	iverilog -o alu_tb.vvp alu_tb.v
	vvp alu_tb.vvp -vcd
	gtkwave alu_tb.vcd

gen_reg:
	iverilog -o gen_reg_tb.vvp gen_reg_tb.v
	vvp gen_reg_tb.vvp -vcd
	gtkwave gen_reg_tb.vcd

inc_reg:
	iverilog -o inc_reg_tb.vvp inc_reg_tb.v
	vvp inc_reg_tb.vvp -vcd
	gtkwave inc_reg_tb.vcd

pointer_segment_registers:
	iverilog -o pointer_segment_regs_tb.vvp pointer_segment_regs_tb.v
	vvp pointer_segment_regs_tb.vvp -vcd
	gtkwave pointer_segment_regs_tb.vcd

programs:
	iverilog -o programs.vvp programs.v
	vvp programs.vvp -vcds
	gtkwave programs.vcd

clean:
	rm -f *.vcd *.vvp