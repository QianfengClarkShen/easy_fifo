`timescale 1ns/1ps
module rst_cntrl (
    input logic rst,
    input logic wr_clk,
    input logic rd_clk,
    output logic wr_rst = 1'b0,
    output logic rd_rst = 1'b0
);
    logic wr_rst_request, rd_rst_request;
    logic wr_rst_rd_synced, rd_rst_wr_synced;

    sync_reset # (
        .N_STAGE(4)
    ) u_sync_reset_wr (
    	.clk        (wr_clk),
        .rst_in     (rst),
        .rst_out    (wr_rst_request)
    );

    sync_reset # (
        .N_STAGE(4)
    ) u_sync_reset_rd (
    	.clk        (rd_clk),
        .rst_in     (rst),
        .rst_out    (rd_rst_request)
    );

    sync_reset # (
        .N_STAGE(6)
    ) u_sync_reset_rd2wr (
    	.clk        (wr_clk),
        .rst_in     (rd_rst),
        .rst_out    (rd_rst_wr_synced)
    );

    sync_reset # (
        .N_STAGE(6)
    ) u_sync_reset_wr2rd (
    	.clk        (rd_clk),
        .rst_in     (wr_rst),
        .rst_out    (wr_rst_rd_synced)
    );

    always_ff @(posedge wr_clk) begin
        if (wr_rst_request)
            wr_rst <= 1'b1;
        else if (rd_rst_wr_synced)
            wr_rst <= 1'b0;
    end

    always_ff @(posedge rd_clk) begin
        if (rd_rst_request)
            rd_rst <= 1'b1;
        else if (wr_rst_rd_synced)
            rd_rst <= 1'b0;
    end

endmodule
