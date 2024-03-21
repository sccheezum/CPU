/*
CS 274
Ursinus College

@author Eugene Thompson
@purpose Implementation of ALU
*/


`include "alu.v"
`default_nettype none

////////////////////////////////////////////////////////////
//                     PROGRAM FLOWS                      //
///////////////////////////////////////////////////////////

//Circuit 1: Trap Mode
//Circuit 2: No Operation 
//Circuit 3: Jump Unconditional
//Circuit 4: Jump Zero
//Circuit 5: Jump Sign
//Circuit 6: Jump Zero-Sign
//Circuit 7: Load Status Register
//Circuit 8: XOR Status Register


////////////////////////////////////////////////////////////
//               LOGIC CLASS OF OPERATIONS               //
///////////////////////////////////////////////////////////

//Circuit 1: 20-bit NOT
module not_ops_tb;
    reg clk;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
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
        .mode(mode),
        .zero(zero)
    );

    initial begin
        a <= 0;
        mode <= 0;

        $dumpfile("alu_tb");
        $dumpvars(1,x0);
        $monitor ("a: %b - c: %b - zero: %b - full-word mode: %b", a, c, zero, mode);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 2: 20-bit AND
module and_ops_tb;
    reg clk;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
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
        .mode(mode),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

    $monitor ("a: %b - b: %b - c: %b - zero: %b - mode: %b", a, b, c, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 3: 20-bit OR
module or_ops_tb;
    reg clk;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
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
        .mode(mode),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - c: %b - zero: %b - mode: %b", a, b, c, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 4: 20-bit XOR
module xor_ops_tb;
    reg clk;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
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
        .mode(mode),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - c: %b - zero: %b - mode: %b", a, b, c, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

////////////////////////////////////////////////////////////////
//               BIT SHIFT CLASS OF OPERATIONS               //
///////////////////////////////////////////////////////////////

//Circuit 1: Shift Right
module shftr_ops_tb;
    reg clk;
    reg [19:0] a;
    wire [19:0] out;
    wire carry;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    shftr_ops x0 (
        .a(a),
        .out(out),
        .carry(carry),
        .zero(zero)
    );

    initial begin
        a <= 0;
        $monitor ("a: %b - out: %b - carry: %b - zero: %b", a, out, carry, zero);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
        end
    end

endmodule

//Circuit 2: Shift Left
module shftl_ops_tb;
    reg clk;
    reg [19:0] a;
    wire [19:0] out;
    wire carry;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    shftl_ops x0 (
        .a(a),
        .out(out),
        .carry(carry),
        .zero(zero)
    );

    initial begin
        a <= 0;
        $monitor ("a: %b - out: %b - carry: %b - zero: %b", a, out, carry, zero);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
        end
    end
endmodule

//Circuit 3: Rotate Right
module rotr_ops_tb;
    reg clk;
    reg mode;
    reg [19:0] a;
    wire [19:0] out;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    rotr_ops x0 (
        .mode(mode),
        .a(a),
        .out(out)
    );

    initial begin
        a <= 0;
        mode <= 0;
        $monitor ("a: %b - out: %b ", a, out);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 4: Rotate Left
module rotl_ops_tb;
    reg clk;
    reg [19:0] a;
    wire [19:0] out;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    rotl_ops x0 (
        .a(a),
        .out(out)
    );

    initial begin
        a <= 0;
        $monitor ("a: %b - out: %b ", a, out);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
        end
    end
endmodule

//Circuit 5: Swap (Exchange)
module swap_ops_tb;
    reg mode;
    reg clk;
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] out_a;
    wire [19:0] out_b;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    swap_ops x0 (
        .mode(mode),
        .a(a),
        .b(b),
        .out_a(out_a),
        .out_b(out_b)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b  - out_a: %b - out_b: %b - mode: %b", a, b, out_a, out_b, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

////////////////////////////////////////////////////////////////
//               ARITHMETIC CLASS OF OPERATIONS              //
///////////////////////////////////////////////////////////////

//Circuit 1: Incrementer
module inc_ops_tb;
    // Set inputs and outputs
    reg mode;
    reg [19:0] a;
    wire [19:0] out;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10531;

    // Instantiate the incrementer
    inc_ops x0 (
        .mode (mode),
        .a (a),
        .out (out),
        .zero (zero)
    );

    initial begin
        a <= 0;
        mode <= 0;

        $monitor ("a: %b - out: %b - zero: %0b - mode: %0b", a, out, zero, mode);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 a <= $urandom(SEED);
            mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 2: Decrementer
module dec_ops_tb;
    // Set inputs and outputs
    reg mode;
    reg [19:0] a;
    wire [19:0] out;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10531;

    // Instantiate the incrementer
    dec_ops x0 (
        .mode(mode),
        .a (a),
        .out (out),
        .zero (zero)
    );

    initial begin
        a <= 0;
        mode <= 0;

        $monitor ("a: %0b - out: %b - zero: %0b - mode: %0b", a, out, zero, mode);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 a <= $urandom(SEED);
            mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 3: Add without Carry
module add_wc_ops_tb;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] c;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    add_wc_ops x0 (
        .a(a),
        .b(b),
        .c(c),
        .mode(mode),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - c: %b - zero: %b - mode: %b", a, b, c, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 4: Add with Carry
module add_c_ops_tb;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] c;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    add_c_ops x0 (
        .a(a),
        .b(b),
        .c(c),
        .mode(mode)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - c: %b - mode: %b", a, b, c, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 5: Subtractor without Carry
module sub_wc_ops_tb;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] c;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    sub_wc_ops x0 (
        .a(a),
        .b(b),
        .c(c),
        .mode(mode),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - c: %b - zero: %b - mode: %b", a, b, c, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 6: Subtractor with Carry
module sub_c_ops_tb;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
    reg [19:0] a;
    reg [19:0] b;
    wire [19:0] c;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    sub_c_ops x0 (
        .a(a),
        .b(b),
        .c(c),
        .mode(mode)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - c: %b - mode: %b", a, b, c, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule


////////////////////////////////////////////////////////////////
//                COMPARISON CLASS OF OPERATIONS              //
///////////////////////////////////////////////////////////////

//Circuit 1: Equal To
module eq_ops_tb;
    reg clk;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
    reg [19:0] a;
    reg [19:0] b;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    eq_ops x0 (
        .mode(mode),
        .a(a),
        .b(b),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - zero: %b - mode - %b", a, b, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 2: Greater Than
module gt_ops_tb;
    reg clk;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
    reg [19:0] a;
    reg [19:0] b;
    wire sign;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    gt_ops x0 (
        .mode(mode),
        .a(a),
        .b(b),
        .sign(sign)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - sign: %b - mode: %b", a, b, sign, mode);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 3: Less Than
module lt_ops_tb;
    reg clk;
    reg mode; //If Mode is 1, then the operation is in full-word mode, otherwise half-word mode
    reg [19:0] a;
    reg [19:0] b;
    wire sign;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    lt_ops x0 (
        .mode(mode),
        .a(a),
        .b(b),
        .sign(sign)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - sign: %b - mode: %b", a, b, sign, mode);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 4: Greater Than or Equal To
module get_ops_tb;
    reg clk;
    reg mode;
    reg [19:0] a;
    reg [19:0] b;
    wire sign;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    get_ops x0 (
        .mode(mode),
        .a(a),
        .b(b),
        .sign(sign),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - sign: %b - zero: %b - mode: %b", a, b, sign, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule

//Circuit 5: Less Than or Equal To
module let_ops_tb;
    reg clk;
    reg mode;
    reg [19:0] a;
    reg [19:0] b;
    wire sign;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    let_ops x0 (
        .mode(mode),
        .a(a),
        .b(b),
        .sign(sign),
        .zero(zero)
    );

    initial begin
        a <= 0;
        b <= 0;
        mode <= 0;

        $monitor ("a: %b - b: %b - sign: %b - zero: %b - mode: %b", a, b, sign, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                b <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end
endmodule