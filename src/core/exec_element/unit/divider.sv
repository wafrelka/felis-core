`timescale 1ps / 100fs

module Divider(

	input logic clk,

	input logic[31:0] a,
	input logic[31:0] b,
	output logic[31:0] c,

	input logic enabled,
	output logic completed

	);

	logic div_valid;
	logic div_ready;
	logic[31:0] divisor;
	logic[31:0] dividend;
	logic[63:0] div_output;

	divider_ip div_submod (
		.aclk(clk),
		.s_axis_divisor_tvalid(div_valid),
		.s_axis_divisor_tdata(divisor),
		.s_axis_dividend_tvalid(div_valid),
		.s_axis_dividend_tdata(dividend),
		.m_axis_dout_tvalid(div_ready),
		.m_axis_dout_tdata(div_output)
	);

	always_comb begin
		divisor = b;
		dividend = a;
	end

	always_ff @(posedge clk) begin

		if(!enabled) begin

			div_valid <= 0;
			completed <= 0;

		end else begin

			if(!div_valid) begin
				div_valid <= 1;
			end else if(div_ready) begin
				completed <= 1;
				c <= div_output[63:32];
			end

		end

	end

endmodule
