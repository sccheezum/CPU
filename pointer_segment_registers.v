/*
 CS 274
 Ursinus College

 @author: Isabelle Son
 */

module instruction_segment_register (
    input clk,
    input [19:0] instruction_segment,
    input [19:0] instruction_pointer,
    output reg [19:0] instruction_address
);

    always @(posedge clk) begin
        instruction_address <= instruction_segment + instruction_pointer;
    end

endmodule

module static_segment_register (
    input clk,
    input [19:0] static_segment,
    input [19:0] static_pointer,
    output reg [19:0] static_address,
    output reg invalid_memory_write
);

    always @(posedge clk) begin
        static_address <= static_segment + static_pointer;
    end

    // Detect invalid memory write by checking if static pointer is less than static segment
    always @(posedge clk) begin
        if (static_pointer < static_segment) begin
            invalid_memory_write <= 1;
        end else begin
            invalid_memory_write <= 0;
        end
    end

endmodule

module dynamic_segment_register (
    input clk,
    input [19:0] dynamic_segment,
    input [4:0] dynamic_pointer,
    input [19:0] write_data,
    input write_enable,
    output reg [19:0] dynamic_address,
    output reg [19:0] read_data
);

    // Registers for memory for the sake of example,, should init memory in a top level module
    reg [19:0] memory [0:19];

    always @(posedge clk) begin
        dynamic_address <= dynamic_segment + dynamic_pointer;
    end

    // Read
    always @(posedge clk) begin
        if (dynamic_pointer >= 0 && dynamic_pointer < 20) begin
            read_data <= 20'b0;
        end else begin
            read_data <= memory[dynamic_pointer];
        end
    end

    // Write
    always @(posedge clk) begin
        if (write_enable && dynamic_pointer >= 0 && dynamic_pointer < 20) begin
            memory[dynamic_pointer] <= write_data;
        end
    end

endmodule