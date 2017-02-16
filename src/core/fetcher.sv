`timescale 1ns / 100ps

module Fetcher(

	input logic clk,
	input logic reset,
	output logic completed,

	input logic[31:0] pc,

	output logic[31:0] inst_mem_out_addr,
	output logic inst_mem_out_valid,
	input logic[31:0] inst_mem_out_data,
	input logic inst_mem_out_ready,

	output logic[5:0] inst_num,
	output logic[15:0] const16,
	output logic[4:0] shift5,
	output logic[25:0] addr26,

	output logic[4:0] in_reg_num [3],
	output logic[4:0] out_reg_num,
	output logic out_general_reg,
	output logic out_float_reg

	);

	logic[31:0] instruction;

	Decoder decoder(.*);

	always_comb begin

		inst_mem_out_addr = pc;
		inst_mem_out_valid = (!reset && !completed);

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;

		end else begin

			if(!completed && inst_mem_out_ready) begin
				instruction <= inst_mem_out_data;
				completed <= 1;
			end

		end

	end

endmodule
