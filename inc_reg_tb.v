/*
CS 274
Ursinus College

@author Michael Cummins
@purpose Implementation of increment registers
*/

`include "inc_reg.v"
`default_nettype none
`timescale 1ns / 1ns

module inc_reg_tb;

    parameter CLK_PERIOD = 10;

    reg clk;
    reg reset;
    reg instruction_complete;
    reg mem_access;
    reg mem_correction;
    wire [19:0] instruction_count;
    wire [19:0] memory_access_count;
    wire [19:0] memory_correction_count;

    inc_reg x0 (
        .clk(clk),
        .reset(reset),
        .instruction_complete(instruction_complete),
        .mem_access(mem_access),
        .mem_correction(mem_correction),
        .instruction_count(instruction_count),
        .memory_access_count(memory_access_count),
        .memory_correction_count(memory_correction_count)
    );

     always #((CLK_PERIOD / 2)) clk = ~clk;

    initial begin
        clk = 0;

        $dumpfile("inc_reg_tb");
        $dumpvars(1,x0);

        reset = 1;

        instruction_complete = 0;
        mem_access = 0;
        mem_correction = 0;

        #20 reset = 0;
        #100;

        instruction_complete = 1;
        #10;
        instruction_complete = 0; 
        #10;

        mem_access = 1;
        #10;
        mem_access = 0; 
        #10;

        mem_correction = 1;
        #10;
        mem_correction = 0; 
        #10

        $finish;
    end

endmodule
