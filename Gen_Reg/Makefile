# CS 274
# Ursinus College
#
# @author: Michael Cummins
# @purpose: Compile the general registers with more ease.

TESTBENCH = gen_reg_tb

all:
	iverilog -o $(TESTBENCH).vvp $(TESTBENCH).v
	vvp $(TESTBENCH).vvp -vcd
	gtkwave $(TESTBENCH).vcd

clean:
	rm -f *.vcd *.vvp