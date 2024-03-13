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
    reg a;
    wire c;
    wire zero;

    not_ops x0 (
        .a(a),
        .c(c),
        .zero(zero)
    );
//Fill in with necessary test conditions:
endmodule