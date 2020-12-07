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

module sync_reset # (
    parameter int N_STAGE = 4
)(
    input logic clk,
    input logic rst_in,
    output logic rst_out
);
    (* ASYNC_REG = "TRUE" *) logic rst_meta[N_STAGE-1:0];

    always_ff @(posedge clk, posedge rst_in) begin
        if (rst_in) begin
            for (int i = 0; i < N_STAGE; i++) begin
                rst_meta[i] <= 1'b1;
            end
        end
        else begin
            rst_meta[0] <= 1'b0;
            for (int i = 1; i < N_STAGE; i++) begin
                rst_meta[i] <= rst_meta[i-1];
            end
        end
    end

    assign rst_out = rst_meta[N_STAGE-1];
endmodule