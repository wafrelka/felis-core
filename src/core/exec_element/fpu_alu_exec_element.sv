module FpuAluExecElement(

	input clk,
	input reset,
	output completed,

	input logic[31:0] pc,
	input logic[5:0] inst_num,
	input logic[15:0] const16,
	input logic[4:0] shift5,
	input logic[25:0] addr26,
	input logic[31:0] rs,
	input logic[31:0] rt,
	input logic[31:0] rd,
	input logic[31:0] fs,
	input logic[31:0] ft,
	input logic[31:0] fd,

	output logic[31:0] out

	);

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;

		end else if(!completed) begin

			completed <= 1;

			// TODO

		end

	end

endmodule
