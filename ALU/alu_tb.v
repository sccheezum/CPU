/*
CS 274
Ursinus College

@author Eugene Thompson
@purpose Implementation of ALU
*/
`include "alu.v"
`default_nettype none


////////////////////////////////////////////////////////////
//               LOGIC CLASS OF OPERATIONS               //
///////////////////////////////////////////////////////////

//Circuit 1: 20-bit NOT

module not_ops_tb;
    reg clk;
    reg [19:0] a;
    wire [19:0] c;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

//Instantiate Circuit
    not_ops x0 (
        .a(a),
        .c(c),
        .zero(zero)
    );

    initial begin
        a <= 0;

        $dumpfile("alu_tb");
        $dumpvars(1,x0);
        $monitor ("a: %b - c: %b - zero: %b", a, c, zero);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
        end
    end
endmodule

//Circuit 2: 20-bit AND
module and_ops_tb;
    reg clk;
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] c;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    and_ops x0 (
        .a(a),
        .b(b),
        .c(c),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;

        $monitor ("a: %b - b: %b - c: %b - zero: %b", a, b, c, zero);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
        end
    end
endmodule

//Circuit 3: 20-bit OR
module or_ops_tb;
    reg clk;
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] c;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    or_ops x0 (
        .a(a),
        .b(b),
        .c(c),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;

        $monitor ("a: %b - b: %b - c: %b - zero: %b", a, b, c, zero);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
        end
    end
endmodule

//Circuit 4: 20-bit XOR
module xor_ops_tb;
    reg clk;
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] c;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    xor_ops x0 (
        .a(a),
        .b(b),
        .c(c),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;

        $monitor ("a: %b - b: %b - c: %b - zero: %b", a, b, c, zero);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
        end
    end
endmodule