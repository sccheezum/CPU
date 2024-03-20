/*
CS 274
Ursinus College

@author Michael Cummins
@purpose Implementation of increment registers
*/

module inc_reg(
    input clk,            
    input reset,          
    input instruction_complete, 
    input mem_access,     
    input mem_correction, 
    output reg [19:0] instruction_count, 
    output reg [19:0] memory_access_count, 
    output reg [19:0] memory_correction_count 
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        instruction_count <= 20'b0;
        memory_access_count <= 20'b0;
        memory_correction_count <= 20'b0;
    end else begin
        if (instruction_complete) begin
            instruction_count <= instruction_count + 1;
        end
        if (mem_access) begin
            memory_access_count <= memory_access_count + 1;
        end
        if (mem_correction) begin
            memory_correction_count <= memory_correction_count + 1;
        end
    end
end

endmodule
