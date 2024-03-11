/*
CS 274
Ursinus College

@author Eugene Thompson
@purpose Implementation of ALU
*/


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

   always @(a or b) begin
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
//Circuit 3: Rotate Right
module rotr_ops (
    input [19:0] a, 
    output reg [19:0] out
);

    integer i;

    always @(r) begin 
    //Setting the first value of the input to the last value of the output
        out[19] = a[0];

    //Iterating through the rest of the input
        for (i = 0; i < 19; i++)begin
            out[i] = a[i+1];
        end
    end
endmodule
//Circuit 4: Rotate Left
//Circuit 5: Swap (Exchange)



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
    output reg zero
);
//Might Change Code Later, but this is the gist
    if (a = b) begin
        zero = 1;
    end 
    else begin
        zero = 0;
    end
endmodule

//Circuit 2: Greater Than
module gt_ops (
    input [19:0] a,
    input [19:0] b,
    output reg sign
);
endmodule
//Circuit 3: Less Than
//Circuit 4: Greater Than or Equal To
//Circuit 5: Less Than or Equal To