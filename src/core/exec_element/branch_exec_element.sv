`timescale 1ps / 100fs

module BranchExecElement(

	input logic clk,
	input logic reset,
	output logic completed,

	input logic[31:0] pc,
	input logic[5:0] inst_num,
	input logic[31:0] const16_x,
	input logic[25:0] addr26,
	input logic[31:0] rs,
	input logic[31:0] rt,

	output logic[31:0] reg_out,
	output logic[31:0] pc_out

	);

	logic cond;
	logic[31:0] const16_x4;

	always_comb begin

		case(inst_num)
			32: cond = (rs == rt);
			33: cond = (rs[31] == 0);
			34: cond = (rs[31] == 0 && rs[30:0] != 0);
			35: cond = (rs[31] == 1 || rs[30:0] == 0);
			36: cond = (rs[31] == 1);
			37: cond = (rs[31] == 0);
			38: cond = (rs[31] == 1);
			default: cond = 1;
		endcase

		const16_x4[31] = const16_x[31];
		const16_x4[30:2] = const16_x[28:0];
		const16_x4[1:0] = 2'b00;

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;

		end else if(!completed) begin

			case(inst_num)

				32, 33, 34, 35, 36, 37, 38: begin
					// BEQ, BGEZ, BGTZ, BLEZ, BLTZ, BGEZAL, BLTZAL

					if(cond)
						pc_out <= pc + const16_x4;
					else
						pc_out <= pc + 4;
					reg_out <= pc + 4;
					completed <= 1;

				end

				39, 40: begin // J, JAL

					pc_out[31:28] <= pc[31:28];
					pc_out[27:2] <= addr26;
					pc_out[1:0] <= pc[1:0];
					reg_out <= pc + 4;
					completed <= 1;

				end

				41, 42: begin // JR, JALR

					pc_out <= rs;
					reg_out <= pc + 4;
					completed <= 1;

				end

				default: completed <= 1;

			endcase

		end

	end

endmodule
