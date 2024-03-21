/*
    CS 274
    Ursinus College

    @author: Susannah Cheezum

 */
`include "pointer_segment_registers.v"

module isr_tb;
    // Set inputs and outputs
    reg clk;
    reg [19:0] instruction_segment;
    reg [19:0] instruction_pointer;
    wire [19:0] instruction_address;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10531;

    instruction_segment_register x0 (
        .clk (clk)
        .instruction_segment (instruction_segment),
        .instruction_pointer (instruction_pointer),
        .instruction_address (instruction_address),
    );

    initial begin
        instruction_segment <= 0;
        instruction_pointer <= 0;

        $dumpfile("ssr_tb.vcd");
        $dumpvars(1,x0);
        $monitor ("clk: 0b%0b - instruction_segment: 0b%0b - instruction_pointer: 0b%0b - instruction_address: 0b%0b", clk, instruction_segment, instruction_pointer, instruction_address);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 a <= $urandom(SEED);
                b <= $urandom(SEED);
        end
    end

endmodule



module ssr_tb;
    // Set inputs and outputs
    reg clk;
    reg [19:0] static_segment;
    reg [19:0] static_pointer;
    wire [19:0] static_address;
    wire invalid_memory_write;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10531;

    instruction_segment_register x0 (
        .clk (clk)
        .static_segment (static_segment),
        .static_pointer (static_pointer),
        .static_address (static_address),
        .invalid_memory_write (invalid_memory_write)
    );

    initial begin
        static_segment <= 0;
        static_pointer <= 0;

        $dumpfile("ssr_tb.vcd");
        $dumpvars(1,x0);
        $monitor ("clk: 0b%0b - static_segment: 0b%0b - static_pointer: 0b%0b - static_address: 0b%0b - invalid_memory_write: 0b%0b", clk, static_segment, static_pointer, static_address, invalid_memory_write);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 static_segment <= $urandom(SEED);
                static_pointer <= $urandom(SEED);
        end
    end

endmodule

module dsr_tb;
    // Set inputs and outputs
    reg clk;
    reg [19:0] dynamic_segment;
    reg [19:0] dynamic_pointer;
    reg [19:0] write_data;
    reg write_enable;
    wire [19:0] dynamic_address;
    wire [19:0] read_data;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10531;

    dynamic_segment_register x0 (
        .clk (clk)
        .dynamic_segment (dynamic_segment),
        .dynamic_pointer (dynamic_pointer),
        .write_data (write_data),
        .write_enable (write_enable),
        .dynamic_address (dynamic_address),
        .read_data (read_data)
    );

    initial begin
        dynamic_segment <= 0;
        dynamic_pointer <= 0;
        write_data <= 0;
        write_enable <= 0;

        $dumpfile("dsr_tb.vcd");
        $dumpvars(1,x0);
        $monitor ("clk: 0b%0b - dynamic_segment: 0b%0b - dynamic_pointer: 0b%0b - write_data: 0b%0b - write_enable: 0b%0b - dynamic_address: 0b%0b - read_data: 0b%0b", clk, dynamic_segment, dynamic_pointer, write_data, write_enable, dynamic_address, read_data);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 dynamic_segment <= $urandom(SEED);
                dynamic_pointer <= $urandom(SEED);
                write_data <= $urandom(SEED);
                write_enable <= $urandom(SEED) % 2;
        end
    end

endmodule