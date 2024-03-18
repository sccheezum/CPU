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
    input clk;
);
    always @(posedge clk | negedge clk) begin
        //Start 4'3" by John Cage...
    end
endmodule
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
module not_ops (
   input [19:0] a,
   output reg [19:0] c,
   output reg zero
);

   integer i;

   always @(a) begin
      for (i = 0; i < 20; i++) begin
         c[i] = ~a[i];
      end
    
      zero = !(|c);
   end  
endmodule

//Circuit 2: 20-bit AND
module and_ops (
   input [19:0] a,
   input [19:0] b,
   output reg [19:0] c,
   output reg zero
);

   integer i;

   always @(a or b) begin
      for (i = 0; i < 20; i++) begin
         c[i] = a[i] & b[i];
      end
    
      zero = !(|c);
   end  
endmodule

//Circuit 3: 20-bit OR
module or_ops (
   input [19:0] a,
   input [19:0] b,
   output reg [19:0] c,
   output reg zero
);

   integer i;

   always @(a or b) begin
      for (i = 0; i < 20; i++) begin
         c[i] = a[i] | b[i];
      end
    
      zero = !(|c);
   end  
endmodule

//Circuit 4: 20-bit XOR
module xor_ops (
   input [19:0] a,
   input [19:0] b,
   output reg [19:0] c,
   output reg zero
);

   integer i;

   always @(a or b) begin
      for (i = 0; i < 20; i++) begin
         c[i] = a[i] ^ b[i];
      end
    
      zero = !(|c);
   end  
endmodule




////////////////////////////////////////////////////////////////
//               BIT SHIFT CLASS OF OPERATIONS               //
///////////////////////////////////////////////////////////////

//Circuit 1: Shift Right (Courtesy of Isabelle taken from "isabelle_circuits.v")
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
    input [19:0] a,
    input [19:0] b,

);
endmodule


////////////////////////////////////////////////////////////////
//               ARITHMETIC CLASS OF OPERATIONS              //
///////////////////////////////////////////////////////////////

//Circuit 1: Incrementer (Courtesy of Isabelle taken from "isabelle_circuits.v")
module inc_ops (
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;

    always @(a) begin
        carry = 1;
        for (i = 19; i >= 0; i--) begin
            out[i] = a[i] + carry;
            if (a[i] == 1 && carry == 1) begin
                carry = 1;
            end else begin
                carry = 0;
            end
        end

        zero = !(|out);
    end

endmodule
//Circuit 2: Decrementer
//Circuit 3: Add without Carry
//Circuit 4: Add with Carry
//Circuit 5: Subtractor without Carry
//Circuit 6: Subtractor with Carry
module sub_c_ops (
    input [19:0] a,
    input [19:0] b,
    output [19:0] c
);
//Implementing Complement Subtraction
    assign c = a + (~b + 1);
endmodule


////////////////////////////////////////////////////////////////
//                COMPARISON CLASS OF OPERATIONS              //
///////////////////////////////////////////////////////////////

//Circuit 1: Equal To
module eq_ops (
    input [19:0] a,
    input [19:0] b,
    output zero
);
    assign zero = (a == b);
endmodule

//Circuit 2: Greater Than
module gt_ops (
    input [19:0] a,
    input [19:0] b,
    output sign
);
    assign sign = a <= b;
endmodule

//Circuit 3: Less Than
module lt_ops (
    input [19:0] a,
    input [19:0] b,
    output sign
);
    assign sign = a < b;
endmodule

//Circuit 4: Greater Than or Equal To
module get_ops (
    input [19:0] a,
    input [19:0] b,
    output sign,
    output zero
);
    assign zero = a >= b;
    assign sign = ~zero;
endmodule

//Circuit 5: Less Than or Equal To
module let_ops (
    input [19:0] a,
    input [19:0] b,
    output sign,
    output zero
);
    assign sign = a <= b;
    assign zero = sign;
endmodule