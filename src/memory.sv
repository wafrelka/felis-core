`timescale 1ns / 100ps

module Memory #(

	parameter integer MEM_BIT_WIDTH = 16

	) (

	input logic clk,
	input logic reset,

	input logic[31:0] in_addr,
	input logic[31:0] in_data,
	input logic in_valid,
	output logic in_ready,

	input logic[31:0] out_addr,
	input logic out_valid,
	output logic[31:0] out_data,
	output logic out_ready

	);

	logic[31:0] memory [2 ** MEM_BIT_WIDTH];

	always_ff @(posedge clk) begin

		if(reset) begin

			in_ready <= 0;
			out_ready <= 0;

		end else begin

			if(in_valid && !in_ready) begin

				memory[in_addr[MEM_BIT_WIDTH+1:2]] <= in_data;
				in_ready <= 1;
				out_ready <= 0;

			end else begin

				in_ready <= 0;

				if(out_valid && !out_ready) begin

					out_data <= memory[out_addr[MEM_BIT_WIDTH+1:2]];
					out_ready <= 1;

				end else begin

					out_ready <= 0;

				end

			end

		end

	end

endmodule
