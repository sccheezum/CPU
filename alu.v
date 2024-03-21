/*
CS 274
Ursinus College

@author Eugene Thompson
@purpose Implementation of ALU
*/

////////////////////////////////////////////////////////////
//                     PROGRAM FLOWS                      //
///////////////////////////////////////////////////////////


//Circuit 1: Trap Mode
//Circuit 2: No Operation 
module no_ops (
    input clk
);
    always @(posedge clk) begin
        //Start 4'3" by John Cage...
    end
endmodule

//Circuit 3: Jump Unconditional
module jmp_ops (
    input clk,
    input [19:0] jmp_addr,
    output reg [19:0] prog_point
);

always @(posedge clk) begin
    prog_point <= jmp_addr;
end

endmodule

//Circuit 4: Jump Zero
module jmpz_ops (
    input clk,
    input [19:0] jmp_addr,
    input zero,
    output reg [19:0] prog_point
);

always @(posedge clk) begin
    if (zero) begin
        prog_point <= jmp_addr;
    end
end

endmodule

//Circuit 5: Jump Sign
module jmps_ops (
    input clk,
    input [19:0] jmp_addr,
    input sign,
    output reg [19:0] prog_point
);

always @(posedge clk) begin
    if (sign) begin
        prog_point <= jmp_addr;
    end
end

endmodule

//Circuit 6: Jump Zero-Sign
module jmpzs_ops (
    input clk,
    input [19:0] jmp_addr,
    input zero,
    output reg [19:0] prog_point
);

always @(posedge clk) begin
    if (zero && sign) begin
        prog_point <= jmp_addr;
    end
end

endmodule

//Circuit 7: Load Status Register
//Circuit 8: XOR Status Register


////////////////////////////////////////////////////////////
//               LOGIC CLASS OF OPERATIONS               //
///////////////////////////////////////////////////////////


//Circuit 1: 20-bit NOT
module not_ops (
   input mode,
   input [19:0] a,
   output reg [19:0] c,
   output reg zero
);

   integer i;
   integer WORD_LENGTH;

   always @(a or mode) begin
    //Full-Word Mode (Iterates Normally through the entire 20-bit register)
      if (mode == 1) begin
        WORD_LENGTH = 20;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = ~a[i];
        end
    //Half-Word Mode (Iterates Through the 20-bit register for the first 10 bits, then leaves the rest blank)
      end else begin
        WORD_LENGTH = 10;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = ~a[i];
        end
        for (i = WORD_LENGTH; i < 20; i++) begin
            c[i] = 0;
        end
      end  
      
      zero = !(|c);
   end  
endmodule

//Circuit 2: 20-bit AND
module and_ops (
   input mode, 
   input [19:0] a,
   input [19:0] b,
   output reg [19:0] c,
   output reg zero
);

   integer i;
   integer WORD_LENGTH;

   always @(a or b or mode) begin
    //Full-Word Mode (Iterates Normally through the entire 20-bit register)
      if (mode == 1) begin
        WORD_LENGTH = 20;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] & b[i];
        end
    //Half-Word Mode (Iterates Through the 20-bit register for the first 10 bits, then leaves the rest blank)
      end else begin
        WORD_LENGTH = 10;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] & b[i];
        end
        for (i = WORD_LENGTH; i < 20; i++) begin
            c[i] = 0;
        end
      end  

      zero = !(|c);
   end  
endmodule

//Circuit 3: 20-bit OR
module or_ops (
   input mode, 
   input [19:0] a,
   input [19:0] b,
   output reg [19:0] c,
   output reg zero
);

   integer i;
   integer WORD_LENGTH;

   always @(a or b or mode) begin
    //Full-Word Mode (Iterates Normally through the entire 20-bit register)
      if (mode == 1) begin
        WORD_LENGTH = 20;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] | b[i];
        end
    //Half-Word Mode (Iterates Through the 20-bit register for the first 10 bits, then leaves the rest blank)
      end else begin
        WORD_LENGTH = 10;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] | b[i];
        end
        for (i = WORD_LENGTH; i < 20; i++) begin
            c[i] = 0;
        end
      end  
    
      zero = !(|c);
   end  
endmodule

//Circuit 4: 20-bit XOR
module xor_ops (
   input mode, 
   input [19:0] a,
   input [19:0] b,
   output reg [19:0] c,
   output reg zero
);

   integer i;
   integer WORD_LENGTH;

   always @(a or b) begin
    //Full-Word Mode (Iterates Normally through the entire 20-bit register)
      if (mode == 1) begin
        WORD_LENGTH = 20;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] ^ b[i];
        end
    //Half-Word Mode (Iterates Through the 20-bit register for the first 10 bits, then leaves the rest blank)
      end else begin
        WORD_LENGTH = 10;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] ^ b[i];
        end
        for (i = WORD_LENGTH; i < 20; i++) begin
            c[i] = 0;
        end
      end  

      zero = !(|c);
   end  
endmodule


////////////////////////////////////////////////////////////////
//               BIT SHIFT CLASS OF OPERATIONS               //
///////////////////////////////////////////////////////////////

//Circuit 1: Shift Right (Courtesy of Isabelle Son)
module shftr_ops (
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;

    always @(a) begin
        carry = a[19];
        out[0] = 0;
        for (i = 1; i < 20; i++) begin
            out[i] = a[i-1];
        end

        zero = !(|out);
    end

endmodule

//Circuit 2: Shift Left
module shftl_ops (
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;

    always @(a) begin
        carry = a[0];
        out[19] = 0;
        for (i = 19; i > 0; i--) begin
            out[i-1] = a[i];
        end

        zero = !(|out);
    end

endmodule

//Circuit 3: Rotate Right
module rotr_ops (
    input [19:0] a, 
    output reg [19:0] out
);

    integer i;

    always @(a) begin 
    //Setting the last value of the input to the last value of the output
        out[0] = a[19];

    //Iterating through the rest of the input
        for (i = 19; i > 0; i--) begin
            out[i] = a[i-1];
        end
    end
endmodule

//Circuit 4: Rotate Left
module rotl_ops (
    input [19:0] a, 
    output reg [19:0] out
);

    integer i;

    always @(a) begin 
    //Setting the first value of the input to the last value of the output
        out[19] = a[0];
    //Iterating through the rest of the input
        for (i = 0; i < 19; i++)begin
            out[i] = a[i+1];
        end
    end
endmodule

//Circuit 5: Swap (Exchange)
module swap_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output reg [19:0] out_a,
    output reg [19:0] out_b
);
    always @(a or b) begin
    //If the two registers are equal than perform no operation
    //by simply passing it through it's respective output register
        if (a == b) begin
            out_a <= a;
            out_b <= b;
    //If the Two Registers are unequal and its in Full-Word Mode
    //Swap the Registers
        end else if (a != b && mode == 1) begin
            out_a <= b;
            out_b <= a;
    //If the Two Registers are unequal and its in Half-Word Mode
    //Swap the Lower Registers and set the Higher Registers to 0
        end else if (a != b && mode == 0) begin
            out_a[9:0] <= b[9:0];
            out_a[19:10] = 0;

            out_b[9:0] <= a[9:0];
            out_b[19:10] = 0;
        end
    end
endmodule


////////////////////////////////////////////////////////////////
//               ARITHMETIC CLASS OF OPERATIONS              //
///////////////////////////////////////////////////////////////

//Circuit 1: Incrementer (Courtesy of Isabelle Son)
module inc_ops (
    input mode,
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;
    integer MAX_BITS;

    always @(a) begin
        assign MAX_BITS = (mode == 1) ? (19) : (9);
        carry = 1;
        for (i = MAX_BITS; i >= 0; i--) begin
            out[i] = a[i] + carry;
            if (a[i] == 1 && carry == 1) begin
                carry = 1;
            end else begin
                carry = 0;
            end
        end
        if (mode == 0) begin
            for (i = 9; i < 20; i++)begin
                out[i] = 0;
            end
        end

        zero = !(|out);
    end

endmodule

//Circuit 2: Decrementer
module dec_ops (
    input mode,
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;
    integer MAX_BITS;

    always @(a) begin
        MAX_BITS = (mode == 1) ? 19 : 9;
        carry = 0;
        for (i = MAX_BITS; i >= 0; i--) begin
            out[i] = a[i] + carry + 1;
            if (a[i] == 1 || carry == 1) begin
                carry = 1;
            end else begin
                carry = 0;
            end
        end

        if (mode == 0) begin
            for (i = 9; i < 20; i++) begin
                out[i] = 0;
            end
        end
        zero = !(|out);
    end

endmodule

//Circuit 3: Add without Carry
module add_wc_ops (
    input mode, 
    input [19:0] a,
    input [19:0] b,
    output reg [19:0] c,
    output reg zero
);

   integer i;
   integer WORD_LENGTH;

   always @(a or b) begin
    //Full-Word Mode (Iterates Normally through the entire 20-bit register)
      if (mode == 1) begin
        WORD_LENGTH = 20;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] ^ b[i];
        end
    //Half-Word Mode (Iterates Through the 20-bit register for the first 10 bits, then leaves the rest blank)
      end else begin
        WORD_LENGTH = 10;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] ^ b[i];
        end
        for (i = WORD_LENGTH; i < 20; i++) begin
            c[i] = 0;
        end
      end  

      zero = !(|c);
   end  
endmodule

//Circuit 4: Add with Carry
module add_c_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output [19:0] c
);
//Implementing Complement Subtraction
    assign c = (mode == 0) ? (a[9:0] + b[9:0]) : (a + b);
endmodule

//Circuit 5: Subtractor without Carry
module sub_wc_ops (
    input mode, 
    input [19:0] a,
    input [19:0] b,
    output reg [19:0] c,
    output reg zero
);

   integer i;
   integer WORD_LENGTH;

   always @(a or b) begin
    //Full-Word Mode (Iterates Normally through the entire 20-bit register)
      if (mode == 1) begin
        WORD_LENGTH = 20;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] ^ b[i];
        end
    //Half-Word Mode (Iterates Through the 20-bit register for the first 10 bits, then leaves the rest blank)
      end else begin
        WORD_LENGTH = 10;
        for (i = 0; i < WORD_LENGTH; i++) begin
            c[i] = a[i] ^ b[i];
        end
        for (i = WORD_LENGTH; i < 20; i++) begin
            c[i] = 0;
        end
      end  

      zero = !(|c);
   end  
endmodule

//Circuit 6: Subtractor with Carry
module sub_c_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output [19:0] c
);
//Implementing Complement Subtraction
    assign c = (mode == 0) ? (a[9:0] + (~b[9:0] + 1)) : (a + (~b + 1));
endmodule


////////////////////////////////////////////////////////////////
//                COMPARISON CLASS OF OPERATIONS              //
///////////////////////////////////////////////////////////////

//Circuit 1: Equal To
module eq_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output zero
);
//If the mode is in Half-Word, then it compares the lower 10-bits of the register
//Otherwise it compares all 20-bits of the register
//If A = B then the zero flag is 1, otherwise 0
    assign zero = (mode == 0) ? (a[9:0] == b[9:0]) : (a == b);
endmodule

//Circuit 2: Greater Than
module gt_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output sign
);
//If the mode is in Half-Word, then it compares the lower 10-bits of the register
//Otherwise it compares all 20-bits of the register
//Because the sign flag is set to 0 if A > B, then taking A <=B where
//the sign flag is set to 1, satisfies this operation :)
    assign sign = (mode == 0) ? (a[9:0] <= b[9:0]) : (a <= b);
endmodule

//Circuit 3: Less Than
module lt_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output sign
);
//If the mode is in Half-Word, then it compares the lower 10-bits of the register
//Otherwise it compares all 20-bits of the register
//If A < B then the sign flag is set to 1, otherwise 0
    assign sign = (mode == 0) ? (a[9:0] < b[9:0]) : (a < b);
endmodule

//Circuit 4: Greater Than or Equal To
module get_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output sign,
    output zero
);
//If the mode is in Half-Word, then it compares the lower 10-bits of the register
//Otherwise it compares all 20-bits of the register
//Since if A >= B then it sets zero to 1, and sign is set to 0 from zero
    assign zero = (mode == 0) ? (a[9:0] >= b[9:0]) : (a >= b);
    assign sign = ~zero;
endmodule

//Circuit 5: Less Than or Equal To
module let_ops (
    input mode,
    input [19:0] a,
    input [19:0] b,
    output sign,
    output zero
);
//If the mode is in Half-Word, then it compares the lower 10-bits of the register
//Otherwise it compares all 20-bits of the register
//Since if A <= B then both flags are set to 1
    assign sign = (mode == 0) ? (a[9:0] <= b[9:0]) : (a <= b);
    assign zero = sign;
endmodule