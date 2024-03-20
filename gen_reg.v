/*
CS 274
Ursinus College

@author Michael Cummins
@purpose Implementation of 6 general registers
*/

module gen_reg(
    input wire clk,
    input wire [1:0] addr_sel, // Address selection (0 for full, 1 for higher bits, 2 for lower bits)
    input wire [9:0] addr,     // Address to read/write data
    input wire [19:0] data_in,  // Data to be written into register
    output reg [19:0] data_out  // Data read from the selected register
);

reg [19:0] registers [5:0]; // Array of six 20-bit registers

always @(posedge clk) begin
    case (addr_sel)
        2'b00: // Full word access
            if (addr < 6) begin
                data_out <= registers[addr];
            end
        2'b01: // Higher 10 bits access
            if (addr < 6) begin
                data_out <= registers[addr][19:10];
            end
        2'b10: // Lower 10 bits access
            if (addr < 6) begin
                data_out <= registers[addr][9:0];
            end
        default:
            data_out <= 20'h0; // Default output to 0 if invalid address selection
    endcase
end

always @(posedge clk) begin
    if (addr_sel == 2'b00 && addr < 6) begin
        registers[addr] <= data_in;
    end
    else if (addr_sel == 2'b01 && addr < 6) begin
        registers[addr][19:10] <= data_in;
    end
    else if (addr_sel == 2'b10 && addr < 6) begin
        registers[addr][9:0] <= data_in;
    end
end

endmodule
