/*
CS 274
Ursinus College

@author Michael Cummins
@purpose Implementation of 6 general registers
*/

`include "gen_reg.v"
`default_nettype none
`timescale 1ns / 1ps

module gen_reg_tb;

    parameter CLK_PERIOD = 10;
    
    reg clk;
    reg [1:0] addr_sel;
    reg [9:0] addr;
    reg [19:0] data_in;
    wire [19:0] data_out;
    
    gen_reg x0 (
        .clk(clk),
        .addr_sel(addr_sel),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    always #((CLK_PERIOD / 2)) clk = ~clk;
    
    initial begin
        clk = 0;
        addr_sel = 2'b00; // Full word access
        
        $dumpfile("gen_reg_tb");
        $dumpvars(1,x0);

        // Write data to register 0
        addr = 0;
        data_in = 20'b10101010101010101010;
        #10;
        
        // Read data from register 0
        addr = 0;
        #10;
        $display("Data from register 0 (Full word access): %h", data_out);
        
        // Write data to register 1 (Higher 10 bits)
        addr_sel = 2'b01;
        addr = 1;
        data_in = 20'b11001100110011001100;
        #10;
        
        // Read data from register 1 (Higher 10 bits)
        addr = 1;
        #10;
        $display("Data from register 1 (Higher 10 bits): %h", data_out);
        
        // Write data to register 2 (Lower 10 bits)
        addr_sel = 2'b10;
        addr = 2;
        data_in = 20'b11110000111100001111;
        #10;
        
        // Read data from register 2 (Lower 10 bits)
        addr = 2;
        #10;
        $display("Data from register 2 (Lower 10 bits): %h", data_out);
        
        // End simulation
        $finish;
    end
    
endmodule