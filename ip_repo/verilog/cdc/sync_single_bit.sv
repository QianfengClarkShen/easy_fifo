`timescale 1ns/1ps
//only remove metastability for each bit, not guarantee relationship between bits.
module sync_signle_bit #
(
    parameter int SIZE = 1,
    parameter int N_STAGE = 2,
    parameter int INPUT_REG = 0
)
(
    input logic clk_in = 1'b0,
    input logic clk_out,
    input logic rst,
    input logic [SIZE-1:0] din,
    output logic [SIZE-1:0] dout
);
    logic [SIZE-1:0] dint;
    (* ASYNC_REG = "TRUE" *) logic [SIZE-1:0] d_meta[N_STAGE-1:0];
    if (INPUT_REG) begin
        always_ff @(posedge clk_in or posedge rst) begin
            if (rst)
                dint <= {SIZE{1'b0}};
            else
                dint <= din;
        end
    end
    else begin
        assign dint = din;
    end

    always_ff @(posedge clk_out or posedge rst) begin
        if (rst)
            d_meta[0] <= {SIZE{1'b0}};
        else
            d_meta[0] <= dint;
    end

    genvar i;
    for (i = 1; i < N_STAGE; i=i+1) begin
        always_ff @(posedge clk_out or posedge rst) begin
            if (rst)
                d_meta[i] <= {SIZE{1'b0}};
            else
                d_meta[i] <= d_meta[i-1];
        end
    end
    assign dout = d_meta[N_STAGE-1];
endmodule