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
module trap_ops_tb;
endmodule
//Circuit 2: No Operation 
module no_ops_tb;
    reg clk;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;
//Instantiate Circuit
    no_ops x0 (
        .clk(clk)
    );

    initial begin
        clk <= 0;

        $monitor ("clk: %b", clk);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 clk <= ~clk;
        end
    end
endmodule

//Circuit 3: Jump Unconditional
module jmp_ops_tb;
    reg clk;
    reg [19:0] jmp_addr;
    wire [19:0] prog_point;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;
    //Instantiate Circuit
    jmp_ops x0 (
        .clk(clk),
        .jmp_addr(jmp_addr),
        .prog_point(prog_point)
    );

    initial begin
        jmp_addr <= 0;
        clk <= 0;

        $monitor ("clk: %b - jmp_addr: %b - prog_point: %b", clk, jmp_addr, prog_point);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 clk <= ~clk;
                jmp_addr <= $urandom(SEED);
        end
    end
endmodule

//Circuit 4: Jump Zero
module jmpz_ops_tb;
    reg zero;
    reg [19:0] jmp_addr;
    wire [19:0] prog_point;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;
    //Instantiate Circuit
    jmpz_ops x0 (
        .zero(zero),
        .jmp_addr(jmp_addr),
        .prog_point(prog_point)
    );

    initial begin
        zero <= 0;
        jmp_addr <= 0;

        $monitor ("zero: %b - jmp_addr: %b - prog_point: %b", zero, jmp_addr, prog_point);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 zero <= $urandom(SEED);
                jmp_addr <= $urandom(SEED);
        end
    end
endmodule

//Circuit 5: Jump Sign
module jmps_ops_tb;
    reg sign;
    reg [19:0] jmp_addr;
    wire [19:0] prog_point;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;
    //Instantiate Circuit
    jmps_ops x0 (
        .sign(sign),
        .jmp_addr(jmp_addr),
        .prog_point(prog_point)
    );

    initial begin
        sign <= 0;
        jmp_addr <= 0;

        $monitor ("sign: %b - jmp_addr: %b - prog_point: %b", sign, jmp_addr, prog_point);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 sign <= $urandom(SEED);
                jmp_addr <= $urandom(SEED);
        end
    end
endmodule

//Circuit 6: Jump Zero-Sign
module jmpzs_ops_tb;
    reg zero;
    reg sign;
    reg [19:0] jmp_addr;
    wire [19:0] prog_point;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;
    //Instantiate Circuit
    jmpzs_ops x0 (
        .zero(zero),
        .sign(sign),
        .jmp_addr(jmp_addr),
        .prog_point(prog_point)
    );

    initial begin
        zero <= 0;
        sign <= 0;
        jmp_addr <= 0;

        $monitor ("zero: %b - sign: %b - jmp_addr: %b - prog_point: %b", zero, sign, jmp_addr, prog_point);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 zero <= $urandom(SEED);
                sign <= $urandom(SEED);
                jmp_addr <= $urandom(SEED);
        end
    end
endmodule

//Circuit 7: Load Status Register
module lstat_ops_tb;
    reg [12:0] status_reg;
    wire [20:0] gen_reg;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;
//Instantiate Circuit
    lstat_ops x0 (
        .status_reg(status_reg),
        .gen_reg(gen_reg)
    );

    initial begin
        status_reg <= 0;

        $monitor ("status_reg: %b - gen_reg: %b", status_reg, gen_reg);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 status_reg <= $urandom(SEED);
        end
    end
endmodule

//Circuit 8: XOR Status Register
module xstat_ops_tb;
    reg [12:0] status_reg;
    reg [20:0] current_reg;
    reg trap_flag;
    wire [20:0] storage_reg;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;
//Instantiate Circuit
    xstat_ops x0 (
        .status_reg(status_reg),
        .current_reg(current_reg),
        .trap_flag(trap_flag),
        .storage_reg(storage_reg)
    );

    initial begin
        status_reg <= 0;
        current_reg <= 0;
        trap_flag <= 0;

        $monitor ("status_reg: %b - current_reg: %b - storage_reg: %b - trap_flag: %b", status_reg, current_reg, storage_reg, trap_flag);

        for (i = 0; i < MAX_ITERS; i++) begin
            #10 status_reg <= $urandom(SEED);
            current_reg <= $urandom(SEED);
            trap_flag <= $urandom(SEED);
        end
    end
endmodule

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
    reg mode;
    reg [19:0] a;
    wire [19:0] out;
    wire carry;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    shftr_ops x0 (
        .a(a),
        .mode(mode),
        .out(out),
        .carry(carry),
        .zero(zero)
    );

    initial begin
        a <= 0;
        mode <= 0;
        $monitor ("a: %b - out: %b - carry: %b - zero: %b - mode: %b", a, out, carry, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                mode <= $urandom(SEED);
        end
    end

endmodule

//Circuit 2: Shift Left
module shftl_ops_tb;
    reg clk;
    reg mode;
    reg [19:0] a;
    wire [19:0] out;
    wire carry;
    wire zero;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    shftl_ops x0 (
        .a(a),
        .mode(mode),
        .out(out),
        .carry(carry),
        .zero(zero)
    );

    initial begin
        a <= 0;
        mode <= 0;
        $monitor ("a: %b - out: %b - carry: %b - zero: %b - mode: %b", a, out, carry, zero, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                mode <= $urandom(SEED);
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
        $monitor ("a: %b - out: %b - mode: %b ", a, out, mode);

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
    reg mode;
    reg [19:0] a;
    wire [19:0] out;

    integer i;
    integer MAX_ITERS = 10;
    integer SEED = 10559;

    rotl_ops x0 (
        .mode(mode),
        .a(a),
        .out(out)
    );

    initial begin
        a <= 0;
        mode <= 0;
        $monitor ("a: %b - out: %b - mode: %b", a, out, mode);

        for (i = 0; i < MAX_ITERS; i++)begin
            #10 clk <= ~clk;
                a <= $urandom(SEED);
                mode <= $urandom(SEED);
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