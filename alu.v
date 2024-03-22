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
module trap_ops (
    input clk,
    input reset,
    input [19:0] instruction,
    output reg trap_flag
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            trap_flag <= 0;
        end else if (instruction[19:14] == 6'b000000) begin
            trap_flag <= 1;
        end else begin
            trap_flag <= 0;
        end
    end
endmodule

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
    input [19:0] jmp_addr,
    input zero,
    output reg [19:0] prog_point
);

    always @(zero) begin
        if (zero) begin
            prog_point <= jmp_addr;
        end 
    end

endmodule

//Circuit 5: Jump Sign
module jmps_ops (
    input [19:0] jmp_addr,
    input sign,
    output reg [19:0] prog_point
);

    always @(sign) begin
        if (sign) begin
            prog_point <= jmp_addr;
        end 
    end

endmodule

//Circuit 6: Jump Zero-Sign
module jmpzs_ops (
    input [19:0] jmp_addr,
    input zero,
    input sign,
    output reg [19:0] prog_point
);

    always @(zero or sign) begin
        if (zero == 1 && sign == 1) begin
            prog_point = jmp_addr;
        end 
    end

endmodule

//Circuit 7: Load Status Register
module lstat_ops (
    input [12:0] status_reg,
    output reg [19:0] gen_reg
);
    always @(status_reg) begin
        gen_reg[12:0] <= status_reg;
        gen_reg[19:13] = 0;
    end
endmodule

//Circuit 8: XOR Status Register
module xstat_ops (
    input [12:0] status_reg,
    input [19:0] current_reg,
    input trap_flag, //1 if in TRAP mode, otherwise not
    output reg [19:0] storage_reg
);
    integer i;
    reg [19:0] temp_reg;


    always @(status_reg or current_reg) begin
        temp_reg[12:0] = status_reg;
        temp_reg[19:13] = 0;
        if (trap_flag == 1) begin
            for (i = 0; i < 20; i++) begin
                storage_reg[i] = temp_reg[i] ^ current_reg[i];
            end
        end else begin
            storage_reg = 0;
        end
    end
endmodule


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
    input mode,
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;
    integer CARRY_DIGIT;
    integer MAX_DIGIT;

    always @(a) begin
        CARRY_DIGIT = (mode == 1) ? (19) : (9);
        MAX_DIGIT = (mode == 1) ? (20) : (10);
        carry = a[CARRY_DIGIT];
        out[0] = 0;
        for (i = 1; i < MAX_DIGIT; i++) begin
            out[i] = a[i-1];
        end
    //If in Half Mode, Puts 0's in the Upper Register
        if (mode == 0) begin
            for (i = 10; i < 20; i++) begin
                out[i] = 0;
            end
        end

        zero = !(|out);
    end

endmodule

//Circuit 2: Shift Left
module shftl_ops (
    input mode,
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;
    integer LAST_DIGIT;

    always @(a) begin
        LAST_DIGIT = (mode == 1) ? (19) : (9);
        carry = a[0];
        out[LAST_DIGIT] = 0;
        for (i = LAST_DIGIT; i > 0; i--) begin
            out[i-1] = a[i];
        end
    //If in Half Mode, Puts 0's in the Upper Register
        if (mode == 0) begin
            for (i = 10; i < 20; i++) begin
                out[i] = 0;
            end
        end

        zero = !(|out);
    end

endmodule

//Circuit 3: Rotate Right
module rotr_ops (
    input mode,
    input [19:0] a, 
    output reg [19:0] out
);

    integer i;
    integer LAST_VALUE;

    always @(a) begin 
        LAST_VALUE = (mode == 1) ? (19) : (9);
    //Setting the last value of the input to the first value of the output
        out[0] = a[LAST_VALUE];

    //Iterating through the rest of the input
        for (i = LAST_VALUE; i > 0; i--) begin
            out[i] = a[i-1];
        end
    //If in Half Mode, Puts 0's in the Upper Register
        if (mode == 0) begin
            for (i = 10; i < 20; i++) begin
                out[i] = 0;
            end
        end
    end
endmodule

//Circuit 4: Rotate Left
module rotl_ops (
    input mode,
    input [19:0] a, 
    output reg [19:0] out
);

    integer i;
    integer LAST_VALUE;

    always @(a) begin 
        LAST_VALUE = (mode == 1) ? (19) : (9);
    //Setting the first value of the input to the last value of the output
        out[LAST_VALUE] = a[0];
    //Iterating through the rest of the input
        for (i = 0; i < LAST_VALUE; i++)begin
            out[i] = a[i+1];
        end
    //If in Half Mode, Puts 0's in the Upper Register
        if (mode == 0) begin
            for (i = 10; i < 20; i++) begin
                out[i] = 0;
            end
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

//Circuit 1: Incrementer
module inc_ops (
    input mode,
    input [19:0] a,
    output reg [19:0] out,
    output reg carry,
    output reg zero
);

    integer i;

    always @(a) begin
    //If the mode is in Full-Word Mode, then it increments the whole register by 1
        if (mode == 1) begin
            out = a + 1;
    //Otherwise if it is in Half-Word Mode, then it increment the lower register by 1
    //Then it leaves the upper register as 0;
        end else begin
            out[9:0] = a[9:0] + 1;
            out[19:10] = 0;
        end

        zero = !(|out);
    end

endmodule

//Circuit 2: Decrementer
module dec_ops (
    input mode,
    input [19:0] a,
    output reg [19:0] out,
    output reg zero
);

    integer i;

    always @(a) begin
    //If the mode is in Full-Word Mode, then it increments the whole register by 1
        if (mode == 1) begin
            out = a - 1;
    //Otherwise if it is in Half-Word Mode, then it increment the lower register by 1
    //Then it leaves the upper register as 0;
        end else begin
            out[9:0] = a[9:0] - 1;
            out[19:10] = 0;
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