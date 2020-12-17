`timescale 1ns/1ps
`define WIDTH_VAL(x) x <= 0 ? 1 : x

module easy_fifo #
(
    parameter bit ASYNC = 0,
    parameter bit AXIS = 0,
    parameter int DWIDTH = 32,
    parameter int DEPTH = 16,
    parameter bit INPUT_REG = 0,
    parameter bit OUTPUT_REG = 0,
//AXIS specific paramters
    parameter bit HAS_KEEP = 0,
    parameter bit HAS_LAST = 0,
    parameter bit HAS_STRB = 0,
    parameter int DEST_WIDTH = 0,
    parameter int USER_WIDTH = 0,
    parameter int ID_WIDTH = 0
)
(
    input logic rst,
//clk
    input logic clk,
    input logic rd_clk,
    input logic wr_clk,
    input logic s_axis_aclk,
    input logic m_axis_aclk,
//regular fifo interface
    input logic [DWIDTH-1:0] wr_data,
    input logic wr_en,
    output logic wr_full,
    input logic rd_en,
    output logic [DWIDTH-1:0] rd_data,
    output logic rd_empty,
//axis interface
    input logic [DWIDTH-1:0] s_axis_tdata,
    input logic s_axis_tvalid,
    input logic [DWIDTH/8-1:0] s_axis_tkeep,
    input logic s_axis_tlast,
    input logic [DWIDTH/8-1:0] s_axis_tstrb,
    input logic [`WIDTH_VAL(DEST_WIDTH)-1:0] s_axis_tdest,
    input logic [`WIDTH_VAL(USER_WIDTH)-1:0] s_axis_tuser,
    input logic [`WIDTH_VAL(ID_WIDTH)-1:0] s_axis_tid,
    input logic m_axis_tready,
    output logic s_axis_tready,
    output logic [DWIDTH-1:0] m_axis_tdata,
    output logic m_axis_tvalid,
    output logic [DWIDTH/8-1:0] m_axis_tkeep,
    output logic m_axis_tlast,
    output logic [DWIDTH/8-1:0] m_axis_tstrb,
    output logic [`WIDTH_VAL(DEST_WIDTH)-1:0] m_axis_tdest,
    output logic [`WIDTH_VAL(USER_WIDTH)-1:0] m_axis_tuser,
    output logic [`WIDTH_VAL(ID_WIDTH)-1:0] m_axis_tid,
//fifo counter
	output logic [$clog2(DEPTH):0] fifo_cnt_wr_synced,
	output logic [$clog2(DEPTH):0] fifo_cnt_rd_synced,
	output logic [$clog2(DEPTH):0] fifo_cnt
);
    localparam int VEC_WIDTH = DWIDTH+DWIDTH/8*HAS_KEEP+DWIDTH/8*HAS_STRB+HAS_LAST+DEST_WIDTH+USER_WIDTH+ID_WIDTH;
    localparam int TDATA_IDX = DWIDTH-1;
    localparam int TKEEP_IDX = TDATA_IDX+DWIDTH/8*HAS_KEEP;
    localparam int TSTRB_IDX = TKEEP_IDX+DWIDTH/8*HAS_STRB;
    localparam int TLAST_IDX = TSTRB_IDX+HAS_LAST;
    localparam int TDEST_IDX = TLAST_IDX+DEST_WIDTH;
    localparam int TUSER_IDX = TDEST_IDX+USER_WIDTH;
    localparam int TID_IDX = TUSER_IDX+ID_WIDTH;

    logic [VEC_WIDTH-1:0] input_vec, output_vec;
    if (AXIS) begin
        if (ASYNC) begin
            easy_fifo_axis_async #(
                .DWIDTH     (VEC_WIDTH),
                .DEPTH      (DEPTH),
                .INPUT_REG  (INPUT_REG),
                .OUTPUT_REG (OUTPUT_REG)
            ) u_easy_fifo_axis_async(
                .*,
                .s_axis_tdata(input_vec),
                .m_axis_tdata(output_vec)
            );
        end
        else begin
            easy_fifo_axis_sync #(
                .DWIDTH     (VEC_WIDTH),
                .DEPTH      (DEPTH),
                .INPUT_REG  (INPUT_REG),
                .OUTPUT_REG (OUTPUT_REG)
            ) u_easy_fifo_axis_sync(
                .*,
                .s_axis_tdata(input_vec),
                .m_axis_tdata(output_vec)
            );
        end
        assign input_vec[TDATA_IDX-:DWIDTH] = s_axis_tdata;
        assign m_axis_tdata = output_vec[TDATA_IDX-:DWIDTH];
        if (HAS_KEEP) begin
            assign input_vec[TKEEP_IDX-:DWIDTH/8*HAS_KEEP] = s_axis_tkeep;
            assign m_axis_tkeep = output_vec[TKEEP_IDX-:DWIDTH/8*HAS_KEEP];
        end
        if (HAS_STRB) begin
            assign input_vec[TSTRB_IDX-:DWIDTH/8*HAS_STRB] = s_axis_tstrb;
			assign m_axis_tstrb = output_vec[TSTRB_IDX-:DWIDTH/8*HAS_STRB];
        end
        if (HAS_LAST) begin
            assign input_vec[TLAST_IDX-:1] = s_axis_tlast;
			assign m_axis_tlast = output_vec[TLAST_IDX-:1];
        end
        if (DEST_WIDTH != 0) begin
            assign input_vec[TDEST_IDX-:DEST_WIDTH] = s_axis_tdest;
			assign m_axis_tdest = output_vec[TDEST_IDX-:DEST_WIDTH];
        end
        if (USER_WIDTH != 0) begin
            assign input_vec[TUSER_IDX-:USER_WIDTH] = s_axis_tuser;
			assign m_axis_tuser = output_vec[TUSER_IDX-:USER_WIDTH];
        end
        if (ID_WIDTH != 0) begin
            assign input_vec[TID_IDX-:ID_WIDTH] = s_axis_tid;
			assign m_axis_tid = output_vec[TID_IDX-:ID_WIDTH];
        end
    end
    else begin
        if (ASYNC) begin
            easy_fifo_async #(
                .DWIDTH     (DWIDTH),
                .DEPTH      (DEPTH),
                .INPUT_REG  (INPUT_REG),
                .OUTPUT_REG (OUTPUT_REG)
            ) u_easy_fifo_async (
                .*
            );
        end
        else begin
            easy_fifo_sync #(
                .DWIDTH     (DWIDTH),
                .DEPTH      (DEPTH),
                .INPUT_REG  (INPUT_REG),
                .OUTPUT_REG (OUTPUT_REG)
            ) u_easy_fifo_sync(
                .*
            );
        end
    end
endmodule
