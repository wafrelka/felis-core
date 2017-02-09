`timescale 1ps / 100fs

module AluExecElement(

	input logic clk,
	input logic reset,
	output logic completed,

	input logic[31:0] pc,
	input logic[5:0] inst_num,
	input logic[15:0] const16,
	input logic[31:0] const16_x,
	// input logic[4:0] shift5,
	input logic[31:0] rs,
	input logic[31:0] rt,

	output logic[31:0] out

	);

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;

		end else if(!completed) begin

			case(inst_num)

				8: begin // ADD

					out <= rs + rt;
					completed <= 1;

				end

				9: begin // ADDI

					out <= rs + const16_x;
					completed <= 1;

				end

				10: begin // SUB

					out <= rs - rt;
					completed <= 1;

				end

				11: begin // LUI

					out[31:16] <= const16;
					out[15:0] <= 16'h0000;
					completed <= 1;

				end

				12: begin // DIV

					// FIXME
					out[31] <= rs[31];
					out[30] <= rs[31];
					out[29:0] <= rs[30:1];
					completed <= 1;

				end

				13: begin // MULT

					// FIXME
					out[31] <= rs[31];
					out[30:1] <= rs[29:0];
					out[0] <= 0;
					completed <= 1;

				end

				16: begin // SLL

					// TODO
					completed <= 1;

				end

				17: begin // SRA

					// TODO
					completed <= 1;

				end

				18: begin // SRL

					// TODO
					completed <= 1;

				end

				20: begin // AND

					out <= rs & rt;
					completed <= 1;

				end

				21: begin // ANDI

					out[31:16] <= 16'h0000;
					out[15:0] <= rs[15:0] & const16;
					completed <= 1;

				end

				22: begin // OR

					out <= rs | rt;
					completed <= 1;

				end

				23: begin // ORI

					out[31:16] <= rs[31:16];
					out[15:0] <= rs[15:0] | const16;
					completed <= 1;

				end

				24: begin // XOR

					out <= rs ^ rt;
					completed <= 1;

				end

				25: begin // XORI

					out[31:16] <= rs[31:16];
					out[15:0] <= rs[15:0] ^ const16;
					completed <= 1;

				end

				26: begin // NOR

					out <= ~(rs | rt);
					completed <= 1;

				end

				default: completed <= 1;

			endcase

		end

	end

endmodule
