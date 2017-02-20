`timescale 1ns / 100ps

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
	logic div_sent;
	logic[31:0] divisor;
	logic[31:0] dividend;
	logic[63:0] div_output;

	DividerIP div_submod (
		.aclk(clk),
		.s_axis_divisor_tvalid(div_valid),
		.s_axis_divisor_tdata(divisor),
		.s_axis_divisor_tready(),
		.s_axis_dividend_tvalid(div_valid),
		.s_axis_dividend_tdata(dividend),
		.s_axis_dividend_tready(),
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
			div_sent <= 0;
			completed <= 0;

		end else begin

			if(!div_valid && !div_sent && !completed) begin
				div_valid <= 1;
				div_sent <= 1;
			end else begin
				div_valid <= 0;
			end

			if(div_ready) begin
				div_sent <= 0;
				c <= div_output[63:32];
				completed <= 1;
			end

		end

	end

endmodule
