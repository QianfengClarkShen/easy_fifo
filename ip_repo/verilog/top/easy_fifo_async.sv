`timescale 1ns/1ps
module easy_fifo_async #
(
    parameter int DWIDTH = 32,
    parameter int DEPTH = 16,
    parameter int INPUT_REG = 0,
    parameter int OUTPUT_REG = 1
)
(
    input logic rst,
    input logic rd_clk = 1'b0,
    input logic wr_clk = 1'b0,
    input logic [DWIDTH-1:0] wr_data = {DWIDTH{1'b0}},
    input logic wr_en = 1'b0,
    output logic wr_full,
    input logic rd_en = 1'b1,
    output logic [DWIDTH-1:0] rd_data,
    output logic rd_empty,
	output logic [$clog2(DEPTH):0] fifo_cnt_wr_synced,
	output logic [$clog2(DEPTH):0] fifo_cnt_rd_synced
);
//internal rsts
    logic wr_rst, rd_rst;

//internal data
    logic [DWIDTH-1:0] wr_data_int, rd_data_int;
    logic wr_en_int, rd_en_int;
    logic wr_full_int, rd_empty_int;

//internal signals for ASYNC and DEPTH > 16
    logic [DWIDTH-1:0] rd_data_async;
    logic wr_full_async, rd_empty_async;


    if (INPUT_REG) begin
        always_ff @(posedge wr_clk) begin
            if (wr_rst) begin
                wr_data_int <= {DWIDTH{1'b0}};
                wr_en_int <= 1'b0;
            end
			else if (~wr_full) begin
                wr_data_int <= wr_data;
                wr_en_int <= wr_en;
            end
        end
		assign wr_full = (wr_full_int & wr_en_int) | wr_rst;
    end
    else begin
        assign wr_data_int = wr_data;
        assign wr_en_int = wr_en;
		assign wr_full = wr_full_int | wr_rst;
    end
    if (OUTPUT_REG) begin
        always_ff @(posedge rd_clk) begin
            if (rd_rst) begin
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
        assign rd_empty = rd_empty_int | rd_rst;
		assign rd_en_int = rd_en;
    end

    if (DEPTH <= 16) begin
        async_fifo #(
            .DWIDTH (DWIDTH),
            .DEPTH  (DEPTH)
        ) u_async_fifo (
	        .*,
            .wr_en    (wr_en_int),
            .rd_en    (rd_en_int),
            .wr_data  (wr_data_int),
            .wr_full  (wr_full_int),
            .rd_data  (rd_data_int),
            .rd_empty (rd_empty_int)
        );
    end
    else begin
		logic [4:0] fifo_cnt_wr_synced_short;
		logic [4:0] fifo_cnt_rd_synced_short;
		logic [$clog2(DEPTH-16):0] fifo_cnt_wr_synced_long;
		logic [$clog2(DEPTH-16):0] fifo_cnt_rd_synced_long;
		logic [$clog2(DEPTH-16):0] fifo_cnt_wr_synced_long_gray;
		logic [$clog2(DEPTH-16):0] fifo_cnt_rd_synced_long_gray;

        async_fifo #(
            .DWIDTH (DWIDTH),
            .DEPTH  (16)
        ) u_async_fifo (
	        .*,
            .wr_en    (wr_en_int),
            .rd_en    (~wr_full_async),
            .wr_data  (wr_data_int),
            .wr_full  (wr_full_int),
            .rd_data  (rd_data_async),
            .rd_empty (rd_empty_async),
			.fifo_cnt_wr_synced (fifo_cnt_wr_synced_short),
			.fifo_cnt_rd_synced (fifo_cnt_rd_synced_short)
        );
        sync_fifo #(
            .DWIDTH   (DWIDTH),
            .DEPTH    (DEPTH-16)
        ) u_sync_fifo (
        	.clk      (rd_clk),
            .rst      (rd_rst),
            .wr_data  (rd_data_async),
            .wr_en    (~rd_empty_async),
            .rd_en    (rd_en_int),
            .rd_data  (rd_data_int),
            .wr_full  (wr_full_async),
            .rd_empty (rd_empty_int),
			.fifo_cnt (fifo_cnt_rd_synced_long)
        );

		bin2gray # (
			.SIZE	($clog2(DEPTH-16)+1)
		) u_bin2gray (
			.bin	(fifo_cnt_rd_synced_long),
			.gray	(fifo_cnt_rd_synced_long_gray)
		);

		sync_signle_bit #(
			.SIZE		($clog2(DEPTH-16)+1),
			.N_STAGE	(2),
			.INPUT_REG	(1)
		) u_sync_signle_bit1 (
			.clk_in  (rd_clk),
			.clk_out (wr_clk),
			.rst     (rst),
			.din     (fifo_cnt_rd_synced_long_gray),
			.dout    (fifo_cnt_wr_synced_long_gray)
		);

		gray2bin #(
			.SIZE ($clog2(DEPTH-16)+1)
		) u_gray2bin (
			.gray (fifo_cnt_wr_synced_long_gray),
			.bin  (fifo_cnt_wr_synced_long)
		);

		always_ff @(posedge wr_clk) begin
			if (wr_rst)
				fifo_cnt_wr_synced <= {($clog2(DEPTH)+1){1'b0}};
			else
				fifo_cnt_wr_synced <= fifo_cnt_wr_synced_short + fifo_cnt_wr_synced_long;		
		end

		always_ff @(posedge rd_clk) begin
			if (rd_rst)
				fifo_cnt_rd_synced <= {($clog2(DEPTH)+1){1'b0}};
			else
				fifo_cnt_rd_synced <= fifo_cnt_rd_synced_short + fifo_cnt_rd_synced_long;
		end
    end

    rst_cntrl u_rst_cntrl(.*);
    
endmodule
