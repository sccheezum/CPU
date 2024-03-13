# CS 274
# Ursinus College
#
# @author: Eugene Thompson
# @purpose: Demonstrate the implementation of simple operations


TESTBENCH=alu_tb

all:
	iverilog -o $(TESTBENCH).vvp $(TESTBENCH).v
	vvp $(TESTBENCH).vvp -vcd
	gtkwave $(TESTBENCH).vcd

clean:
	rm -f *.vcd *.vvp