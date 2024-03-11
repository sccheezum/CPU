//circuit 1: 20-bit decoder
module decoder (
    input [3:0] a,
    output reg [15:0] out
);

    integer i;

    always @(a) begin
        for(i = 0; i < 16; i++) begin
            if (i != a) begin
                out[i] = 0;
            end else begin
                out[i] = 1;
            end
        end
    end

endmodule

//circuit 2: 20-bit AND
module and_20_bit (
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

//circuit 3: shift right
module shftr (
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

//circuit 4: incrementer
module inc (
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