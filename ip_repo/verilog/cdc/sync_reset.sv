`timescale 1ns/1ps
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
