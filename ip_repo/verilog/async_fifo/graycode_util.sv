`timescale 1ns/1ps
module graycntr #
(
    parameter int SIZE = 4
)
(
    input logic rst,
    input logic clk,
    input logic inc,
    output logic [SIZE-1:0] gray
);
    logic [SIZE-1:0] bin;
    logic [SIZE-1:0] bin_reg;
    always_ff @(posedge clk) begin
        if (rst) begin
            bin_reg <= {SIZE{1'b0}};
            gray <= {SIZE{1'b0}};
        end
        else begin
            bin_reg <= bin;
            gray <= (bin>>1) ^ bin;
        end
    end
    assign bin = bin_reg + inc;
endmodule

module gray2bin #
(
    parameter int SIZE = 4
)
(
    input logic [SIZE-1:0] gray,
    output logic [SIZE-1:0] bin
);
    genvar i;
    for (i=0; i<SIZE; i=i+1) begin
        assign bin[i] = ^(gray>>i);
    end
endmodule

module bin2gray #
(
	parameter SIZE = 4
)
(
	input logic [SIZE-1:0] bin,
	output logic [SIZE-1:0] gray
);
	assign gray = (bin>>1) ^ bin;
endmodule
