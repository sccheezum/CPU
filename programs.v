/*
CS 274
Ursinus College

@author Michael Cummins
@purpose Test bench for the control unit
*/

`include "control_unit.v"
`default_nettype none
`timescale 1ns / 1ps

module program;

    reg clk;                  // Clock input
    reg reset;                // Reset input
    reg [19:0] instruction;   // Current instruction
    reg zero_flag;            // Zero flag
    reg sign_flag;            // Sign flag
    reg overflow_flag;        // Overflow flag
    reg underflow_flag;       // Underflow flag
    reg carry_flag_fw;        // Carry flag for full word mode
    reg carry_flag_hwl;       // Carry flag for half-word mode for low bits
    reg carry_flag_hwh;       // Carry flag for half-word mode for high bits
    reg div_by_zero_flag;     // Division by zero flag
    reg half_word_mode;       // Half-word mode flag
    reg same_reg_flag;        // Same register flag
    reg mem_violation_flag;   // Memory violation flag
    reg mem_corruption_flag;  // Memory corruption flag
    reg trap_mode_flag;       // Trap mode flag
    reg [19:0] registers [5:0]; // General Registers
    wire fetch_enable;        // Enable signal for instruction fetch stage
    wire decode_enable;       // Enable signal for instruction decode stage
    wire execute_enable;      // Enable signal for instruction execute stage
    wire write_back_enable;   // Enable signal for write-back stage

    control_unit xo (
        .clk(clk),                  // Clock input
        .reset(reset),              // Reset input
        .instruction(instruction), // Current instruction
        .zero_flag(zero_flag),      // Zero flag
        .sign_flag(sign_flag),      // Sign flag
        .overflow_flag(overflow_flag),  // Overflow flag
        .underflow_flag(underflow_flag), // Underflow flag
        .carry_flag_fw(carry_flag_fw),  // Carry flag for full word mode
        .carry_flag_hwl(carry_flag_hwl), // Carry flag for half-word mode for low bits
        .carry_flag_hwh(carry_flag_hwh), // Carry flag for half-word mode for high bits
        .div_by_zero_flag(div_by_zero_flag), // Division by zero flag
        .half_word_mode(half_word_mode),   // Half-word mode flag
        .same_reg_flag(same_reg_flag),    // Same register flag
        .mem_violation_flag(mem_violation_flag), // Memory violation flag
        .mem_corruption_flag(mem_corruption_flag), // Memory corruption flag
        .trap_mode_flag(trap_mode_flag),   // Trap mode flag
        .registers(registers),         // General Registers
        .fetch_enable(fetch_enable),   // Enable signal for instruction fetch stage
        .decode_enable(decode_enable), // Enable signal for instruction decode stage
        .execute_enable(execute_enable),   // Enable signal for instruction execute stage
        .write_back_enable(write_back_enable) // Enable signal for write-back stage
    );

    // Stimulus generation
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, program);

        // Initialize inputs
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Provide stimulus
        #20;

        //Trap state
        instruction = 20'b00000000000000000000;
        #20;

        //And with inputs from registers 4 and 5 and store result in register 0 in full word mode
        registers[4] = 20'b01010101010101010101;
        registers[5] = 20'b11111111111111111111;
        instruction = 20'b00100110010100000010;
        #20;

        //Greater than with inputs in registers 3 and 4 stored in register 2 in full word mode
        registers[3] = 20'b00000000001011000010;
        registers[4] = 20'b00000000000011001010;
        instruction = 20'b01100001110001000010;
        #20;

        //Jump zero to address specified in register 1
        registers[1] = 20'b00000000000000000010;
        instruction = 20'b00001100100000000000;

        #100 $finish;
    end

    always #5 clk = ~clk;

endmodule