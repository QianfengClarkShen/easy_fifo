`timescale 1ns/1ps
module easy_fifo_sync #
(
    parameter int DWIDTH = 32,
    parameter int DEPTH = 16,
    parameter int INPUT_REG = 0,
    parameter int OUTPUT_REG = 0
)
(
    input logic rst,
    input logic clk,
    input logic [DWIDTH-1:0] wr_data,
    input logic wr_en,
    output logic wr_full,
    input logic rd_en,
    output logic [DWIDTH-1:0] rd_data,
    output logic rd_empty,
	output logic [$clog2(DEPTH):0] fifo_cnt
);
//internal clocks
    logic wr_clk_int, rd_clk_int;

//internal data
    logic [DWIDTH-1:0] wr_data_int, rd_data_int;
    logic wr_en_int, rd_en_int;
    logic wr_full_int, rd_empty_int;

    assign wr_clk_int = clk;
    assign rd_clk_int = clk;

    if (INPUT_REG) begin
        always_ff @(posedge wr_clk_int) begin
            if (rst) begin
                wr_data_int <= {DWIDTH{1'b0}};
                wr_en_int <= 1'b0;
            end
            else if (~wr_full) begin
                wr_data_int <= wr_data;
                wr_en_int <= wr_en;
            end
        end
	 	assign wr_full = wr_full_int & wr_en_int;
    end
    else begin
        assign wr_data_int = wr_data;
        assign wr_en_int = wr_en;
		assign wr_full = wr_full_int;
    end
    if (OUTPUT_REG) begin
        always_ff @(posedge rd_clk_int) begin
            if (rst) begin
                rd_data <= {DWIDTH{1'b0}};
                rd_empty <= 1'b1;
            end
            else if (rd_en_int) begin
                rd_data <= rd_data_int;
                rd_empty <= rd_empty_int;
            end
        end
		assign rd_en_int = rd_en | rd_empty;
    end
    else begin
        assign rd_data = rd_data_int;
        assign rd_empty = rd_empty_int;
		assign rd_en_int = rd_en;
    end

    sync_fifo #(
        .DWIDTH   (DWIDTH),
        .DEPTH    (DEPTH)
    ) u_sync_fifo (
    	.clk      (clk),
        .rst      (rst),
        .wr_data  (wr_data_int),
        .wr_en    (wr_en_int),
        .rd_en    (rd_en_int),
        .rd_data  (rd_data_int),
        .wr_full  (wr_full_int),
        .rd_empty (rd_empty_int),
		.fifo_cnt (fifo_cnt)
    );
endmodule
