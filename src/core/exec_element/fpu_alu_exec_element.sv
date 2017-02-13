`timescale 1ps / 100fs

module FpuAluExecElement(

	input logic clk,
	input logic reset,
	output logic completed,

	input logic[5:0] inst_num,
	input logic[31:0] fs,
	input logic[31:0] ft,

	output logic[31:0] out

	);

	logic addsub_valid, addsub_ready, addsub_sent;
	logic[31:0] addsub_output;
	logic[7:0] addsub_op;

	logic mul_valid, mul_ready, mul_sent;
	logic[31:0] mul_output;
	logic div_valid, div_ready, div_sent;
	logic[31:0] div_output;

	logic itf_valid, itf_ready, itf_sent;
	logic[31:0] itf_output;
	logic[31:0] itf_count;
	localparam logic[31:0] itf_delay = 3;

	logic fti_valid, fti_ready, fti_sent;
	logic[31:0] fti_output;

	FPAddSubIP fp_addsub_submod (
		.aclk(clk),
		.s_axis_a_tvalid(addsub_valid), .s_axis_a_tdata(fs),
		.s_axis_b_tvalid(addsub_valid), .s_axis_b_tdata(ft),
		.s_axis_operation_tvalid(addsub_valid), .s_axis_operation_tdata(addsub_op),
		.m_axis_result_tvalid(addsub_ready), .m_axis_result_tdata(addsub_output)
	);

	FPMulIP fp_mul_submod (
		.aclk(clk),
		.s_axis_a_tvalid(mul_valid), .s_axis_a_tdata(fs),
		.s_axis_b_tvalid(mul_valid), .s_axis_b_tdata(ft),
		.m_axis_result_tvalid(mul_ready), .m_axis_result_tdata(mul_output)
	);

	FPDivIP fp_div_submod (
		.aclk(clk),
		.s_axis_a_tvalid(div_valid), .s_axis_a_tdata(fs),
		.s_axis_b_tvalid(div_valid), .s_axis_b_tdata(ft),
		.m_axis_result_tvalid(div_ready), .m_axis_result_tdata(div_output)
	);

	FPFloatToIntIP fp_float_to_int_submod (
		.aclk(clk),
		.s_axis_a_tvalid(fti_valid), .s_axis_a_tdata(fs),
		.m_axis_result_tvalid(fti_ready), .m_axis_result_tdata(fti_output)
	);

	FPIntToFloatIP fp_int_to_float_submod (
		.aclk(clk),
		.s_axis_a_tvalid(itf_valid), .s_axis_a_tdata(fs),
		.m_axis_result_tvalid(itf_ready), .m_axis_result_tdata(itf_output)
	);

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;
			addsub_valid <= 0;
			addsub_sent <= 0;
			mul_valid <= 0;
			mul_sent <= 0;
			div_valid <= 0;
			div_sent <= 0;
			itf_valid <= 0;
			itf_sent <= 0;
			itf_count <= 0;
			fti_valid <= 0;
			fti_sent <= 0;

		end else if(!completed) begin

			case(inst_num)

				54, 55: begin // ABS.S, NEG.S

					out[30:0] <= fs[30:0];
					out[31] <= (inst_num == 54 ? 0 : !fs[31]);
					completed <= 1;

				end

				56, 57: begin // ADD.S, SUB.S

					if(!addsub_valid && !addsub_sent) begin
						addsub_valid <= 1;
						addsub_sent <= 1;
						addsub_op[7:1] <= 0;
						addsub_op[0] <= (inst_num == 57);
					end else begin
						addsub_valid <= 0;
					end

					if(addsub_ready) begin
						addsub_sent <= 0;
						out <= addsub_output;
						completed <= 1;
					end

				end

				58: begin // MUL.S

					if(!mul_valid && !mul_sent) begin
						mul_valid <= 1;
						mul_sent <= 1;
					end else begin
						mul_valid <= 0;
					end

					if(mul_ready) begin
						mul_sent <= 0;
						out <= mul_output;
						completed <= 1;
					end

				end

				59: begin // DIV.S

					if(!div_valid && !div_sent) begin
						div_valid <= 1;
						div_sent <= 1;
					end else begin
						div_valid <= 0;
					end

					if(div_ready) begin
						div_sent <= 0;
						out <= div_output;
						completed <= 1;
					end

				end

				60: begin // CVT.S.W

					if(!itf_valid && !itf_sent) begin
						itf_valid <= 1;
						itf_sent <= 1;
					end else begin
						itf_valid <= 0;
					end

					if(itf_ready && itf_count == 0)
						itf_count <= 1;

					if(itf_count > 0)
						itf_count <= itf_count + 1;

					if(itf_count > itf_delay) begin
						itf_sent <= 0;
						itf_count <= 0;
						out <= itf_output;
						completed <= 1;
					end

				end

				61: begin // CVT.W.S

					if(!fti_valid && !fti_sent) begin
						fti_valid <= 1;
						fti_sent <= 1;
					end else begin
						fti_valid <= 0;
					end

					if(fti_ready) begin
						fti_sent <= 0;
						out <= fti_output;
						completed <= 1;
					end

				end

				62: begin // MOV.S
					out <= fs;
					completed <= 1;
				end

				63: begin // SQRT.S

					// TODO

				end

				default: completed <= 1;

			endcase

		end

	end

endmodule
