`timescale 1ps / 100fs

module MemExecElement(

	input logic clk,
	input logic reset,
	output logic completed,

	input logic[5:0] inst_num,
	input logic[31:0] const16_x,
	input logic[25:0] addr26,
	input logic[31:0] rs,
	input logic[31:0] rt,
	input logic[31:0] rd,
	input logic[31:0] fs,

	output logic[31:0] out,

	output logic[31:0] main_mem_in_addr,
	output logic[31:0] main_mem_in_data,
	output logic main_mem_in_valid,
	input logic main_mem_in_ready,
	output logic[31:0] main_mem_out_addr,
	output logic main_mem_out_valid,
	input logic[31:0] main_mem_out_data,
	input logic main_mem_out_ready

	);

	logic [31:0] addr;

	always_comb begin

		case(inst_num)
			28: addr = rs + const16_x;
			29: addr = rs + rt;
			30: addr = rt + const16_x;
			31: addr = rt + rd;
			48: addr = rs + const16_x;
			49: addr = rs + rt;
			50: addr = rt + const16_x;
			51: addr = rt + rd;
			default: addr = 0;
		endcase

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			completed <= 0;
			main_mem_in_valid <= 0;
			main_mem_out_valid <= 0;

		end else if(!completed) begin

			case(inst_num)

				28, 29, 48, 49: begin // LW, LWO, LWC1, LWOC1

					if(!main_mem_out_valid) begin
						main_mem_out_valid <= 1;
						main_mem_out_addr <= addr;
					end else if(main_mem_out_ready) begin
						main_mem_out_valid <= 0;
						out <= main_mem_out_data;
						completed <= 1;
					end

				end

				30, 31, 50, 51: begin // SW, SWO, SWC1, SCOC1

					if(!main_mem_in_valid) begin
						main_mem_in_valid <= 1;
						main_mem_in_addr <= addr;
						main_mem_in_data <= (inst_num < 32 ? rs : fs);
					end else if(main_mem_in_ready) begin
						main_mem_in_valid <= 0;
						completed <= 1;
					end

				end

				52, 53: begin

					out <= (inst_num == 52 ? rs : fs);
					completed <= 1;

				end

				default: completed <= 1;

			endcase

		end

	end

endmodule
