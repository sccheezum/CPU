/*
CS 274
Ursinus College

@author Michael Cummins
@purpose Implementation control unit
*/

`include "alu.v"
`include "gen_reg.v"
`include "inc_reg.v"
`include "pointer_segment_registers.v"

module ControlUnit (
    input wire clk,              // Clock input
    input wire reset,            // Reset input
    input wire [19:0] instruction, // Current instruction
    input wire zero_flag,        // Zero flag
    input wire sign_flag,        // Sign flag
    input wire overflow_flag,    // Overflow flag
    input wire underflow_flag,   // Underflow flag
    input wire carry_flag_fw,    // Carry flag for full word mode
    input wire carry_flag_hwl,   // Carry flag for half-word mode for low bits
    input wire carry_flag_hwh,   // Carry flag for half-word mode for high bits
    input wire div_by_zero_flag, // Division by zero flag
    input wire half_word_mode,   // Half-word mode flag
    input wire same_reg_flag,    // Same register flag
    input wire mem_violation_flag, // Memory violation flag
    input wire mem_corruption_flag, // Memory corruption flag
    input wire trap_mode_flag,   // Trap mode flag
    output reg fetch_enable,     // Enable signal for instruction fetch stage
    output reg decode_enable,    // Enable signal for instruction decode stage
    output reg execute_enable,   // Enable signal for instruction execute stage
    output reg write_back_enable // Enable signal for write-back stage
);

// Define instruction opcodes
parameter TRAP_OP = 6'b000000; // TRAP: Enters trap mode
parameter NOP_OP = 6'b000001; // NOP: No operation
parameter JMP_OP = 6'b000010; // JMP: Jump Unconditional
parameter JMPZ_OP = 6'b000011; // JMPZ: Jump if Zero
parameter JMPS_OP = 6'b000100; // JMPS: Jump if Sign
parameter JMPZS_OP = 6'b000101; // JMPZS: Jump if Zero and Sign
parameter LSTAT_OP = 6'b000110; // LSTAT: Load Status Register
parameter XSTAT_OP = 6'b000111; // XSTAT: XOR Status Register
parameter NOT_OP = 6'b001000; // NOT: Logical Negation
parameter AND_OP = 6'b001001; // AND: Logical AND
parameter OR_OP = 6'b001010; // OR: Logical OR
parameter XOR_OP = 6'b001011; // XOR: Logical XOR
parameter SHFTR_OP = 6'b001100; // SHFTR: Shift Right
parameter SHFTL_OP = 6'b001101; // SHFTL: Shift Left
parameter ROTR_OP = 6'b001110; // ROTR: Rotate Right
parameter ROTL_OP = 6'b001111; // ROTL: Rotate Left
parameter SWAP_OP = 6'b010000; // SWAP: Exchange Values
parameter INC_OP = 6'b010001; // INC: Increment
parameter DEC_OP = 6'b010010; // DEC: Decrement
parameter ADD_OP = 6'b010011; // ADD: Add
parameter ADDC_OP = 6'b010100; // ADDC: Add with Carry
parameter SUB_OP = 6'b010101; // SUB: Subtract
parameter SUBC_OP = 6'b010110; // SUBC: Subtract with Carry
parameter EQ_OP = 6'b010111; // EQ: Equal Than
parameter GT_OP = 6'b011000; // GT: Greater Than
parameter LT_OP = 6'b011001; // LT: Less Than
parameter GET_OP = 6'b011010; // GET: Greater or Equal Than
parameter LET_OP = 6'b011011; // LET: Less or Equal Than
parameter MRR_OP = 6'b011100; // MRR: Move Register to Register
parameter LDC_OP = 6'b011101; // LDC: Load Constant
parameter LDD_OP = 6'b011110; // LDD: Load Direct
parameter LDI_OP = 6'b011111; // LDI: Load Indirect
parameter STD_OP = 6'b100000; // STD: Store Direct
parameter STI_OP = 6'b100001; // STI: Store Indirect

// Define states
parameter FETCH_STATE = 3'b000; // Fetch state
parameter DECODE_STATE = 3'b001; // Decode state
parameter EXECUTE_STATE = 3'b010; // Execute state
parameter WRITE_BACK_STATE = 3'b011; // Write-back state

reg [2:0] state; // State register

// Signals to control other components
reg [1:0] gen_reg_write_addr; // Address for GPR write operation
reg [19:0] genb_reg_write_data; // Data for GPR write operation
reg alu_op; // Signal to control ALU operation
reg [19:0] alu_src1, alu_src2; // ALU operands
reg alu_mode; //ALU mode (1 = full word, 0 = half word)
reg [19:0] alu_result1, alu_result2; // Result from ALU operation
reg [19:0] pc_next; // Next value for Program Counter
reg jump_flag; // Flag to control jump operation

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to FETCH_STATE
        state <= FETCH_STATE;
        // Enable fetch stage
        fetch_enable <= 1'b1;
        // Disable other stages
        decode_enable <= 1'b0;
        execute_enable <= 1'b0;
        write_back_enable <= 1'b0;
    end else begin
        // State transition logic
        case (state)
            FETCH_STATE: begin
                // Fetch instruction from memory
                // Update state and enable next stage
                state <= DECODE_STATE;
                decode_enable <= 1'b1;
                // Disable previous stage
                fetch_enable <= 1'b0;
            end
            DECODE_STATE: begin
                // Decode instruction and determine control signals for other components
                case (instruction)
                    //ALU Opcode
                    TRAP_OP: begin
                        // assign all necessary data
                    end
                    NOP_OP: begin
                        // assign all necessary data
                    end
                    JMP_OP: begin
                        // assign all necessary data
                    end
                    JMPZ_OP: begin
                        // assign all necessary data
                    end
                    JMPS_OP: begin
                        // assign all necessary data
                    end
                    JMPZS_OP: begin
                        // assign all necessary data
                    end
                    LSTAT_OP: begin
                        // assign all necessary data
                    end
                    XSTAT_OP: begin
                        // assign all necessary data
                    end
                    NOT_OP: begin
                        // assign all necessary data
                    end
                    AND_OP: begin
                        // assign all necessary data
                    end
                    OR_OP: begin
                        // assign all necessary data
                    end
                    XOR_OP: begin
                        // assign all necessary data
                    end
                    SHFTR_OP: begin
                        // assign all necessary data
                    end
                    SHFTL_OP: begin
                        // assign all necessary data
                    end
                    ROTR_OP: begin
                       // assign all necessary data
                    end
                    ROTL_OP: begin
                        // assign all necessary data
                    end
                    SWAP_OP: begin
                        // assign all necessary data
                    end
                    INC_OP: begin
                        // assign all necessary data
                    end
                    DEC_OP: begin
                        // assign all necessary data
                    end
                    ADD_OP: begin
                        // assign all necessary data
                    end
                    ADDC_OP: begin
                        // assign all necessary data
                    end
                    SUB_OP: begin
                        // assign all necessary data
                    end
                    SUBC_OP: begin
                        // assign all necessary data
                    end
                    EQ_OP: begin
                        // assign all necessary data
                    end
                    GT_OP: begin
                        // assign all necessary data
                    end
                    LT_OP: begin
                        // assign all necessary data
                    end
                    GET_OP: begin
                        // assign all necessary data
                    end
                    LET_OP: begin
                        // assign all necessary data
                    end

                    //Register Management Opcode
                    MRR_OP: begin
                        // assign all necessary data
                    end
                    LDC_OP: begin
                        // assign all necessary data
                    end
                    LDD_OP: begin
                        // assign all necessary data
                    end
                    LDI_OP: begin
                        // assign all necessary data
                    end
                    STD_OP: begin
                        // assign all necessary data
                    end
                    STI_OP: begin
                        // assign all necessary data
                    end
                    default: // Handle default case
                endcase
                // Update state and enable next stage
                state <= EXECUTE_STATE;
                execute_enable <= 1'b1;
                // Disable previous stage
                decode_enable <= 1'b0;
            end
            EXECUTE_STATE: begin
                // Execute ALU operation or control flow operation
                case (instruction)

                    //ALU Opcode
                    TRAP_OP: begin
                        // Handle TRAP instruction
                    end
                    NOP_OP: begin
                        no_ops x0(
                            .clk(clk)
                        );
                    end
                    JMP_OP: begin
                        // Handle JMP instruction
                    end
                    JMPZ_OP: begin
                        // Handle JMPZ instruction
                    end
                    JMPS_OP: begin
                        // Handle JMPS instruction
                    end
                    JMPZS_OP: begin
                        // Handle JMPZS instruction
                    end
                    LSTAT_OP: begin
                        // Handle LSTAT instruction
                    end
                    XSTAT_OP: begin
                        // Handle XSTAT instruction
                    end
                    NOT_OP: begin
                        not_ops x0(
                            .mode(alu_mode), 
                            .a(alu_src1),
                            .c(alu_result1),
                            .zero(zero_flag)
                    );
                    end
                    AND_OP: begin
                        and_ops x0(
                            .mode(alu_mode),
                            .a(alu_src1),
                            .b(alu_src2),
                            .c(alu_result1),
                            .zero(zero_flag)
                        );
                    end
                    OR_OP: begin
                        or_ops x0(
                            .mode(alu_mode),
                            .a(alu_src1),
                            .b(alu_src2),
                            .c(alu_result1),
                            .zero(zero_flag)
                        );
                    end
                    XOR_OP: begin
                        xor_ops x0(
                            .mode(alu_mode),
                            .a(alu_src1),
                            .b(alu_src2),
                            .c(alu_result1),
                            .zero(zero_flag)
                        );
                    end
                    SHFTR_OP: begin
                        shiftr_ops x0 (
                            .a(alu_src1),
                            .out(alu_result1),
                            .carry(carry_flag_fw),
                            .zero(zero_flag)
                        );
                    end
                    SHFTL_OP: begin
                        shiftl_ops x0 (
                            .a(alu_src1),
                            .out(alu_result1),
                            .carry(carry_flag_fw),
                            .zero(zero_flag)
                        );
                    end
                    ROTR_OP: begin
                        rotr_ops x0 (
                            .a(alu_src1),
                            .out(alu_result1)
                        );
                    end
                    ROTL_OP: begin
                        rotl_ops x0 (
                            .a(alu_src1),
                            .out(alu_result1)
                        );
                    end
                    SWAP_OP: begin
                        swap_ops x0 (
                            .a(alu_src1),
                            .b(alu_src2),
                            .out_a(alu_result1),
                            .out_b(alu_result2)
                        );
                    end
                    INC_OP: begin
                        inc_ops x0 (
                            .a(alu_src1),
                            .out(alu_result1),
                            .carry(carry_flag_fw),
                            .zero(zero_flag)
                        );
                    end
                    DEC_OP: begin
                        // Handle DEC instruction
                    end
                    ADD_OP: begin
                        // Handle ADD instruction
                    end
                    ADDC_OP: begin
                        // Handle ADDC instruction
                    end
                    SUB_OP: begin
                        // Handle SUB instruction
                    end
                    SUBC_OP: begin
                        // Handle SUBC instruction
                    end
                    EQ_OP: begin
                        eq_ops x0(
                            .a(alu_src1),
                            .b(alu_src2),
                            .zero(zero_flag)
                        );
                    end
                    GT_OP: begin
                        // Handle GT instruction
                    end
                    LT_OP: begin
                        // Handle LT instruction
                    end
                    GET_OP: begin
                        // Handle GET instruction
                    end
                    LET_OP: begin
                        // Handle LET instruction
                    end

                    //Register Management Opcode
                    // *TENTATIVE CHANGES -- Still need to check to make sure this is the correct method of implementation
                    MRR_OP: begin
                        gen_reg_write_addr <= instruction[11:10]; // Destination register address
                        alu_src1 <= registers[instruction[5:4]]; // Source register address
                    end
                    LDC_OP: begin
                        gen_reg_write_addr <= instruction[11:10]; // Destination register address
                        gen_reg_write_data <= instruction[9:0]; // Constant value to be loaded
                    end
                    LDD_OP: begin
                        // Load data from direct memory address into register
                        gen_reg_write_addr <= instruction[11:10]; // Destination register address
                        // Load data from memory address specified in instruction
                        alu_src1 <= instruction[9:0]; // Memory address
                    end
                    LDI_OP: begin
                        // Load data from memory address stored in a register into another register
                        gen_reg_write_addr <= instruction[11:10]; // Destination register address
                        // Load memory address from register
                        alu_src1 <= registers[instruction[9:8]]; // Load memory address from register
                        alu_src2 <= registers[instruction[7:6]]; // Source register address
                    end
                    STD_OP: begin
                        // Store data from register to direct memory address
                        // Read data from the register
                        alu_src1 <= registers[instruction[11:10]]; // Source register address
                        // Store data to memory address specified in instruction
                        alu_src2 <= instruction[9:0]; // Memory address
                    end
                    STI_OP: begin
                        // Store data from register to memory address stored in another register
                        // Read data from the source register
                        alu_src1 <= registers[instruction[11:10]]; // Source register address
                        // Load memory address from register
                        alu_src2 <= registers[instruction[9:8]]; // Memory address
                    end
                    default: // Handle default case
                endcase
                // Update state and enable next stage
                state <= WRITE_BACK_STATE;
                write_back_enable <= 1'b1;
                // Disable previous stage
                execute_enable <= 1'b0;
            end
            WRITE_BACK_STATE: begin
                // Write back results to GPR or update PC
                // Update state and enable next stage
                state <= FETCH_STATE;
                fetch_enable <= 1'b1;
                // Disable previous stage
                write_back_enable <= 1'b0;
            end
            default: // Handle default case
        endcase
    end
end

endmodule