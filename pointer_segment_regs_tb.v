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

    // Instantiate the XOR
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
        static_address <= 0;

        $dumpfile("ssr_tb.vcd");
        $dumpvars(1,x0);
        $monitor ("clk: 0b%0b - static_segment: 0b%0b - static_pointer: 0b%0b - static_address: 0b%0b - invalid_memory_write: 0b%0b", clk, static_segment, static_pointer, static_address, invalid_memory_write);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 a <= $urandom(SEED);
                b <= $urandom(SEED);
        end
    end

endmodule
