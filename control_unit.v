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
`include "s_reg.v"

module control_unit (
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
    input wire trap_mode_flag,    // Trap mode flag
    input wire [5:0] registers,   // General Registers
    output wire fetch_enable,     // Enable signal for instruction fetch stage
    output wire decode_enable,    // Enable signal for instruction decode stage
    output wire execute_enable,   // Enable signal for instruction execute stage
    output wire write_back_enable // Enable signal for write-back stage
);

// Instantiate the status register module
s_reg status_reg(
    .zf(zero_flag),
    .sf(sign_flag),
    .of(overflow_flag),
    .uf(underflow_flag),
    .cffw(carry_flag_fw),
    .cfhl(carry_flag_hwl),
    .cfhh(carry_flag_hwh),
    .df(div_by_zero_flag),
    .hwf(half_word_mode),
    .srf(same_reg_flag),
    .mvf(mem_violation_flag),
    .mcf(mem_corruption_flag),
    .tf(trap_mode_flag),
    .clk(clk),
    .dzf(),   // Connect delayed versions of flags as needed
    .dsf(),
    .dof(),
    .duf(),
    .dcffw(),
    .dcfhl(),
    .dcfhh(),
    .ddf(),
    .dhwf(),
    .dsrf(),
    .dmvf(),
    .dmcf(),
    .dtf()
);

// Instantiate the increment register module with placeholders for mem_access and mem_correction
inc_reg inc_registers(
    .clk(clk),
    .reset(reset),
    .instruction_complete(decode_enable),
    .mem_access(),     // Placeholder for mem_access
    .mem_correction(), // Placeholder for mem_correction
    .instruction_count(), 
    .memory_access_count(), 
    .memory_correction_count()
);

// Instantiate the general register module
gen_reg general_registers(
    .clk(clk),
    .addr_sel(2'b00), // Always select full word access
    .addr(instruction[13:11]), // Use instruction bits to select register address
    .data_in(), // Data to be written into the register (unused in ControlUnit)
    .data_out() // Data read from the selected register
);

// Connect the general registers to the registers array in ControlUnit
assign registers = gen_registers;

// Define instruction opcodes (instruction[19:14])
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

// Register 1 is found with instruction[13:11]
// Register 2 is found with instruction[10:8]
// Destination register 1 is found with instruction[7:5]
// Destination register 2 is found with instruction[4:2] 
// ALU mode (full/half word) found with instruction[1]

// Instruction format: | OPCODE(6b) | SRC_REG1(3b) | SRC_REG2(3b) | DEST_REG1(3b) | DEST_REG2(3b) | ALU_MODE(1b) | EXTRA(1b) |
// e.g 00100110010100000010 = 001001|100|101|000|000|1|0 = AND between registers 4 and 5 stored in register 0 
//                                                         (no need for second store) in full word mode

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

always @(posedge clk) begin
    if (reset) begin
        // Reset the state to FETCH_STATE
        state <= FETCH_STATE;
        // Enable fetch stage
        fetch_enable <= 1'b1;
        // Disable other stages
        decode_enable <= 1'b0;
        execute_enable <= 1'b0;
        write_back_enable <= 1'b0;
        //Disable trap state
        trap_mode_flag <= 1'b0;
    end else begin
        // State transition logic
        case (state)
            FETCH_STATE: begin
                // Fetch instruction from memory (Instructions are recieved upon intialization)
                // Update state and enable next stage
                state <= DECODE_STATE;
                decode_enable <= 1'b1;
                // Disable previous stage
                fetch_enable <= 1'b0;
            end
            DECODE_STATE: begin
                // Decode instruction and determine control signals for other components
                case (instruction[19:14])
                    //ALU Opcode
                    TRAP_OP: begin
                        //No need to change any values used as they are already assigned.
                    end
                    NOP_OP: begin
                        // No operation, so no specific action needed
                    end
                    JMP_OP: begin
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    JMPZ_OP: begin
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        zero_flag <= 1'b0;
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    JMPS_OP: begin
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        sign_flag <= 1'b0;
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    JMPZS_OP: begin
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        zero_flag <= 1'b0;
                        sign_flag <= 1'b0;
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    LSTAT_OP: begin
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                    end
                    XSTAT_OP: begin
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        trap_mode_flag <= 1'b0;
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                    end
                    NOT_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    AND_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    OR_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    XOR_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    SHFTR_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        carry_flag_fw = 1'b0;
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    SHFTL_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        carry_flag_fw = 1'b0;
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    ROTR_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    ROTL_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    SWAP_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        alu_result2 <= registers[instruction[4:2]]; // Destination register 2 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    INC_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        carry_flag_fw = 1'b0;
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    DEC_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        carry_flag_fw = 1'b0;
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    ADD_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    ADDC_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    SUB_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    SUBC_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        alu_result1 <= registers[instruction[7:5]]; // Destination register 1 address

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    EQ_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    GT_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        sign_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    LT_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        sign_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    GET_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        sign_flag = 1'b0;
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                    LET_OP: begin
                        alu_mode <= instruction[1]; // Bit 1 determines ALU mode (full or half word)
                        alu_src1 <= registers[instruction[13:11]]; // Source register 1 address
                        alu_src2 <= registers[instruction[10:8]]; // Source register 2 address
                        sign_flag = 1'b0;
                        zero_flag = 1'b0;

                        alu_op <= 1'b1; // Enable ALU operation for logical negation
                    end
                endcase
                // Update state and enable next stage
                state <= EXECUTE_STATE;
                execute_enable <= 1'b1;
                // Disable previous stage
                decode_enable <= 1'b0;
            end
            EXECUTE_STATE: begin
                if (trap_mode_flag) begin
                    // TRAP instruction executed, so no operation needed
                    // Transition back to fetch state
                    state <= FETCH_STATE;
                    fetch_enable <= 1'b1; // Enable instruction fetching
                    execute_enable <= 1'b0; // Disable execution
                end else begin
                // Execute ALU operation or control flow operation
                    case (instruction[19:14])
                        //ALU Opcode
                        TRAP_OP: begin
                            trap_ops x0(
                                .clk(clk),
                                .reset(reset),
                                .instruction(instruction),
                                .trap_flag(trap_flag)
                            );
                        end
                        NOP_OP: begin
                            no_ops x0(
                                .clk(clk)
                            );
                        end
                        JMP_OP: begin
                            jmp_ops xo(
                                .clk(clk),
                                .jmp_addr(alu_src1),
                                .prog_point(alu_src2)
                            );
                        end
                        JMPZ_OP: begin
                            jmpz_ops xo(
                                .clk(clk),
                                .jmp_addr(alu_src1),
                                .zero(zero_flag),
                                .prog_point(alu_src2)
                            );
                        end
                        JMPS_OP: begin
                            jmps_ops xo(
                                .clk(clk),
                                .jmp_addr(alu_src1),
                                .sign(sign_flag),
                                .prog_point(alu_src2)
                            );
                        end
                        JMPZS_OP: begin
                            jmpzs_ops xo(
                                .clk(clk),
                                .jmp_addr(alu_src1),
                                .zero(zero_flag),
                                .sign(sign_flag),
                                .prog_point(alu_src2)
                            );
                        end
                        LSTAT_OP: begin
                            xstat_ops(
                                .status_reg(status_reg),
                                .gen_reg(alu_src1)
                            );
                        end
                        XSTAT_OP: begin
                            xstat_ops(
                                .status_reg(status_reg),
                                .current_reg(alu_src1),
                                .trap_flag(trap_mode_flag),
                                .storage_reg(alu_result1)
                            );
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
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .out_a(alu_result1),
                                .out_b(alu_result2)
                            );
                        end
                        INC_OP: begin
                            inc_ops x0 (
                                .mode(alu_mode),
                                .a(alu_src1),
                                .out(alu_result1),
                                .carry(carry_flag_fw),
                                .zero(zero_flag)
                            );
                        end
                        DEC_OP: begin
                            dec_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .out(alu_result1),
                                .carry(carry_flag_fw),
                                .zero(zero_flag)
                            );
                        end
                        ADD_OP: begin
                            add_wc_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .c(alu_result1),
                                .zero(zero_flag)
                            );
                        end
                        ADDC_OP: begin
                            add_c_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .c(alu_result1)
                            );
                        end
                        SUB_OP: begin
                            sub_wc_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .c(alu_result1),
                                .zero(zero_flag)
                            );
                        end
                        SUBC_OP: begin
                            sub_c_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .c(alu_result1)
                            );
                        end
                        EQ_OP: begin
                            eq_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .zero(zero_flag)
                            );
                        end
                        GT_OP: begin
                            gt_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .sign(sign_flag)
                            );
                        end
                        LT_OP: begin
                            lt_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .sign(sign_flag)
                            );
                        end
                        GET_OP: begin
                            get_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .sign(sign_flag),
                                .zero(zero_flag)
                            );
                        end
                        LET_OP: begin
                            let_ops x0(
                                .mode(alu_mode),
                                .a(alu_src1),
                                .b(alu_src2),
                                .sign(sign_flag),
                                .zero(zero_flag)
                            );
                        end
                    endcase
                end
                // Update state and enable next stage
                state <= WRITE_BACK_STATE;
                write_back_enable <= 1'b1;
                // Disable previous stage
                execute_enable <= 1'b0;
            end
            WRITE_BACK_STATE: begin
                case (instruction[19:14])
                    //ALU Opcode
                    TRAP_OP: begin
                        // No writeback needed
                    end
                    NOP_OP: begin
                        // No writeback needed
                    end
                    JMP_OP: begin
                        // No writeback needed
                    end
                    JMPZ_OP: begin
                        // No writeback needed
                    end
                    JMPS_OP: begin
                        // No writeback needed
                    end
                    JMPZS_OP: begin
                        // No writeback needed
                    end
                    LSTAT_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    XSTAT_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    NOT_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    AND_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    OR_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    XOR_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    SHFTR_OP: begin
                        register[instruction[7:5]] <= alu_result1;
                    end
                    SHFTL_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    ROTR_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    ROTL_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    SWAP_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                        registers[instruction[4:2]] <= alu_result2;
                    end
                    INC_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    DEC_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    ADD_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    ADDC_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    SUB_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    SUBC_OP: begin
                        registers[instruction[7:5]] <= alu_result1;
                    end
                    EQ_OP: begin
                        // No writeback needed
                    end
                    GT_OP: begin
                        // No writeback needed
                    end
                    LT_OP: begin
                        // No writeback needed
                    end
                    GET_OP: begin
                        // No writeback needed
                    end
                    LET_OP: begin
                        // No writeback needed
                    end
                endcase
                // Write back results to GPR or update PC
                // Update state and enable next stage
                state <= FETCH_STATE;
                fetch_enable <= 1'b1;
                // Disable previous stage
                write_back_enable <= 1'b0;
            end
        endcase
    end
end

endmodule