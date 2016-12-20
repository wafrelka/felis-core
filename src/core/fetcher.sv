module Fetcher(

	input logic clk,
	input logic reset,
	output logic completed,

	input logic[31:0] pc,
	output logic[31:0] instruction,

	output logic[31:0] inst_mem_out_addr,
	output logic inst_mem_out_valid,
	input logic[31:0] inst_mem_out_data,
	input logic inst_mem_out_ready

	);

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
