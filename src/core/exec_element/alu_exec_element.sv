`timescale 1ns / 100ps

module AluExecElement(

	input logic clk,
	input logic reset,
	output logic completed,

	input logic[5:0] inst_num,
	input logic[31:0] const16_x,
	input logic[4:0] shift5,
	input logic[31:0] rs,
	input logic[31:0] rt,

	output logic[31:0] out

	);

	logic[31:0] shift [6];
	logic[31:0] div_a, div_b, div_c;
	logic div_enabled, div_completed;

	Divider divider(.clk(clk), .a(div_a), .b(div_b), .c(div_c),
		.enabled(div_enabled), .completed(div_completed));

	always_comb begin

		case(inst_num)

			12: div_b = rt;
			14: div_b = const16_x;
			default: div_b = 1;

		endcase

		div_a = rs;

	end

	always_comb begin
		shift[0] = rs;
	end

	genvar sbit;

	generate
		for(sbit = 0; sbit < 5; ++sbit) begin: ShiftWiring

			always_comb begin

				if(shift5[sbit]) begin

					case(inst_num)

						16: begin // Rs << Shift5
							shift[sbit + 1][31:2**sbit] = shift[sbit][31-2**sbit:0];
							shift[sbit + 1][2**sbit-1:0] = 0;
						end

						17: begin // Rs_x >> Shift5
							shift[sbit + 1][31-2**sbit:0] = shift[sbit][31:2**sbit];
							if(shift[0][31])
								shift[sbit + 1][31:32-2**sbit] = ~0;
							else
								shift[sbit + 1][31:32-2**sbit] = 0;
						end

						18: begin // Rs >> Shift5
							shift[sbit + 1][31-2**sbit:0] = shift[sbit][31:2**sbit];
							shift[sbit + 1][31:32-2**sbit] = 0;
						end

						default: shift[sbit + 1] = shift[sbit];

					endcase

				end else begin

					shift[sbit + 1] = shift[sbit];

				end
			end

		end
	endgenerate

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;
			div_enabled <= 0;

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

					out[31:16] <= const16_x[15:0];
					out[15:0] <= 16'h0000;
					completed <= 1;

				end

				12, 14: begin // DIV, DIVI

					if(!div_enabled) begin
						div_enabled <= 1;
					end else if(div_completed) begin
						out <= div_c;
						div_enabled <= 0;
						completed <= 1;
					end

				end

				13, 15: begin // MULT, MULTI

					if(inst_num == 13)
						out <= $signed(rs) * $signed(rt);
					else
						out <= $signed(rs) * $signed(const16_x);
					completed <= 1;

				end

				16, 17, 18: begin // SLL, SRA, SRL

					out <= shift[5];
					completed <= 1;

				end

				20: begin // AND

					out <= rs & rt;
					completed <= 1;

				end

				21: begin // ANDI

					out[31:16] <= 16'h0000;
					out[15:0] <= rs[15:0] & const16_x[15:0];
					completed <= 1;

				end

				22: begin // OR

					out <= rs | rt;
					completed <= 1;

				end

				23: begin // ORI

					out[31:16] <= rs[31:16];
					out[15:0] <= rs[15:0] | const16_x[15:0];
					completed <= 1;

				end

				24: begin // XOR

					out <= rs ^ rt;
					completed <= 1;

				end

				25: begin // XORI

					out[31:16] <= rs[31:16];
					out[15:0] <= rs[15:0] ^ const16_x[15:0];
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
