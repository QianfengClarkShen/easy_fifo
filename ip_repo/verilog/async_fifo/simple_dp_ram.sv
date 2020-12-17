`timescale 1ns/1ps
module simple_dp_ram #
(
    parameter int DWIDTH = 64,
    parameter int DEPTH = 16
)
(
    input logic wr_clk,
    input logic [DWIDTH-1:0] wr_data,
    input logic [$clog2(DEPTH)-1:0] wr_addr,
    input logic wr_en,
    input logic [$clog2(DEPTH)-1:0] rd_addr,
    output logic [DWIDTH-1:0] rd_data
);
    logic [DWIDTH-1:0] mem_int[DEPTH-1:0];
    always_ff @(posedge wr_clk) begin
        if (wr_en) mem_int[wr_addr] <= wr_data;
    end

    assign rd_data = mem_int[rd_addr];
endmodule