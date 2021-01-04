`timescale 1ns/1ps
module easy_fifo_axis_sync #
(
    parameter int DWIDTH = 32,
    parameter int DEPTH = 16,
    parameter int INPUT_REG = 0,
    parameter int OUTPUT_REG = 0
)
(
    input logic rst,
    input logic clk,
    input logic [DWIDTH-1:0] s_axis_tdata,
    input logic s_axis_tvalid,
    output logic s_axis_tready,
    output logic [DWIDTH-1:0] m_axis_tdata,
    output logic m_axis_tvalid,
    input logic m_axis_tready,
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
            else if (s_axis_tready) begin
                wr_data_int <= s_axis_tdata;
                wr_en_int <= s_axis_tvalid;
            end
		end
		assign s_axis_tready = ~wr_full_int | ~wr_en_int;
    end
    else begin
        assign wr_data_int = s_axis_tdata;
        assign wr_en_int = s_axis_tvalid;
		assign s_axis_tready = ~wr_full_int;
    end
    if (OUTPUT_REG) begin
        always_ff @(posedge rd_clk_int) begin
            if (rst) begin
                m_axis_tdata <= {DWIDTH{1'b0}};
                m_axis_tvalid <= 1'b0;
            end
            else if (rd_en_int) begin
                m_axis_tdata <= rd_data_int;
                m_axis_tvalid <= ~rd_empty_int;
            end
        end
		assign rd_en_int = m_axis_tready | ~m_axis_tvalid;
    end
    else begin
        assign m_axis_tdata = rd_data_int;
        assign m_axis_tvalid = ~rd_empty_int;
		assign rd_en_int = m_axis_tready;
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
