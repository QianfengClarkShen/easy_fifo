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
    output logic rd_empty
);
//internal clocks
    logic wr_clk_int, rd_clk_int;

//internal data
    logic [DWIDTH-1:0] wr_data_int, rd_data_int;
    logic wr_en_int, rd_en_int;
    logic wr_full_int, rd_empty_int;

//internal signals for ASYNC and DEPTH > 16
    logic [DWIDTH-1:0] rd_data_async;
    logic wr_full_async, rd_empty_async;

    assign wr_clk_int = wr_clk;

    assign rd_clk_int = rd_clk;

    assign wr_full = wr_full_int;
    assign rd_en_int = rd_en;

    if (INPUT_REG) begin
        always_ff @(posedge wr_clk_int or posedge rst) begin
            if (rst) begin
                wr_data_int <= {DWIDTH{1'b0}};
                wr_en_int <= 1'b0;
            end
            else begin
                wr_data_int <= wr_data;
                wr_en_int <= wr_en;
            end
       end
    end
    else begin
        assign wr_data_int = wr_data;
        assign wr_en_int = wr_en;
    end
    if (OUTPUT_REG) begin
        always_ff @(posedge rd_clk_int, posedge rst) begin
            if (rst) begin
                rd_data <= {DWIDTH{1'b0}};
                rd_empty <= 1'b1;
            end
            else begin
                rd_data <= rd_data_int;
                rd_empty <= rd_empty_int;
            end
        end
    end
    else begin
        assign rd_data = rd_data_int;
        assign rd_empty = rd_empty_int;
    end

    if (DEPTH <= 16) begin
        async_fifo #(
            .DWIDTH (DWIDTH),
            .DEPTH  (16)
        ) u_async_fifo (
	        .rst      (rst),
            .wr_clk   (wr_clk_int),
            .rd_clk   (rd_clk_int),
            .wr_en    (wr_en_int),
            .rd_en    (rd_en_int),
            .wr_data  (wr_data_int),
            .wr_full  (wr_full_int),
            .rd_data  (rd_data_int),
            .rd_empty (rd_empty_int)
        );
    end
    else begin
        async_fifo #(
            .DWIDTH (DWIDTH),
            .DEPTH  (16)
        ) u_async_fifo (
	        .rst      (rst),
            .wr_clk   (wr_clk_int),
            .rd_clk   (rd_clk_int),
            .wr_en    (wr_en_int),
            .rd_en    (~wr_full_async),
            .wr_data  (wr_data_int),
            .wr_full  (wr_full_int),
            .rd_data  (rd_data_async),
            .rd_empty (rd_empty_async)
        );
        sync_fifo #(
            .DWIDTH   (DWIDTH),
            .DEPTH    (DEPTH-16)
        ) u_sync_fifo (
        	.clk      (rd_clk_int),
            .rst      (rst),
            .wr_data  (rd_data_async),
            .wr_en    (~rd_empty_async),
            .rd_en    (rd_en_int),
            .rd_data  (rd_data_int),
            .wr_full  (wr_full_async),
            .rd_empty (rd_empty_int)
        );
    end

endmodule
