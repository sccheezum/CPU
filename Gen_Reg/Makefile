# CS 274
# Ursinus College
#
# @author: Michael Cummins
# @purpose: Compile the general registers with more ease.

all:
	iverilog -o gen_reg_tb.vvp gen_reg_tb.v
	vvp gen_reg_tb.vvp -vcd
	gtkwave gen_reg_tb.vcd

clean:
	rm -f *.vcd *.vvp