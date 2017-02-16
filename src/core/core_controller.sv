`timescale 1ns / 100ps

module CoreController(

	input logic clk,
	input logic reset,

	output logic fetcher_reset,
	input logic fetcher_completed,
	output logic[31:0] pc,

	output logic executor_reset,
	input logic executor_completed,

	input logic[4:0] in_reg_num [3],
	input logic[4:0] out_reg_num,
	input logic out_general_reg,
	input logic out_float_reg,

	output logic[31:0] float_in_regs [3],
	output logic[31:0] general_in_regs [3],
	input logic[31:0] exec_reg_out,
	input logic[31:0] exec_pc_out

	);

	enum integer {INIT, FETCH, EXEC} state;

	logic[31:0] general_regs [32];
	logic[31:0] float_regs [32];

	always_comb begin

		fetcher_reset = (state != FETCH);
		executor_reset = (state != EXEC);
		general_regs[0] = 0;

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			state <= INIT;

		end else begin

			if(state == INIT)
				state <= FETCH;
			else if(state == FETCH && fetcher_completed)
				state <= EXEC;
			else if(state == EXEC && executor_completed)
				state <= FETCH;

		end

	end

	always_ff @(posedge clk) begin

		if(reset)
			pc <= 0;
		else if(state == EXEC && executor_completed)
			pc[31:2] <= exec_pc_out[31:2];

	end

	genvar in_i;
	generate
		for(in_i = 0; in_i < 3; in_i = in_i + 1) begin: InRegWiring

			always_comb begin
				float_in_regs[in_i] = float_regs[in_reg_num[in_i]];
				general_in_regs[in_i] = general_regs[in_reg_num[in_i]];
			end

		end
	endgenerate

	genvar out_i;
	generate
		for(out_i = 0; out_i < 32; out_i = out_i + 1) begin: OutRegWiring

			always_ff @(posedge clk) begin

				if(reset) begin

					if(out_i != 0)
						general_regs[out_i] <= 0;
					float_regs[out_i] <= 0;

				end else if(state == EXEC && executor_completed) begin

					if(out_i != 0 && out_i == out_reg_num && out_general_reg)
						general_regs[out_reg_num] <= exec_reg_out;
					if(out_i == out_reg_num && out_float_reg)
						float_regs[out_reg_num] <= exec_reg_out;

				end

			end

		end
	endgenerate

endmodule
