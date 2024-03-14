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