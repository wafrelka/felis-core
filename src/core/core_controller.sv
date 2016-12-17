module Core(

	input logic clk,
	input logic reset,

	output fetcher_reset,
	input fetcher_completed,
	output logic[31:0] pc,
	input logic[31:0] instruction,

	output logic executor_reset,
	input logic executor_completed,
	output logic[5:0] inst_num,
	output logic[15:0] const16,
	output logic[4:0] shift5,
	output logic[25:0] addr26,
	output logic[31:0] float_in_regs [3],
	output logic[31:0] general_in_regs [3],
	input logic[31:0] exec_reg_out,
	input logic[31:0] exec_pc_out,

	output logic[31:0] inst_mem_out_addr,
	output logic inst_mem_out_valid,
	input logic[31:0] inst_mem_out_data,
	input logic inst_mem_out_ready,

	);

	localparam integer INIT = 0;
	localparam integer FETCH = 1;
	localparam integer DECODE = 2;
	localparam integer EXEC = 3;

	integer state;

	logic[4:0][31:0] general_regs;
	logic[4:0][31:0] float_regs;

	logic[4:0] in_reg_num [3];
	logic[4:0] out_reg_num;
	logic out_general_reg;
	logic out_float_reg;

	Decoder decoder(.*);

	always_comb begin

		fetcher_reset = (state != FETCH);
		executor_reset = (state != EXEC);

	end

	always_ff @(posedge clk) begin

		if(reset) begin

			state <= INIT;

		end else begin

			if(state == INIT)
				state <= FETCH;
			else if(state == FETCH && fetcher_completed)
				state <= DECODE;
			else if(state == DECODE)
				state <= EXEC;
			else if(state == EXEC && executor_completed)
				state <= FETCH;
			end

		end

	end

	always_ff @(posedge clk) begin

		if(reset)
			pc <= 0;
		else if(state == EXEC && executor_completed)
			pc[31:2] <= exec_pc_out[31:2];

	end

	generate
		always_comb begin

			genvar reg_num_idx;

			for(reg_num_idx = 0; reg_num_idx < 3; reg_num_idx++) begin
				float_in_regs[reg_num_idx] = float_regs[in_reg_num[reg_num_idx]];
				general_in_regs[reg_num_idx] = general_regs[in_reg_num[reg_num_idx]];
			end

		end
	endgenerate

	generate
		always_ff @(posedge clk) begin

			genvar regs_idx;

			for(regs_idx = 0; regs_idx < 32; regs_idx++) begin

				if(reset) begin

					general_regs[regs_idx] <= 0;
					float_regs[regs_idx] <= 0;

				end else if(state == EXEC && executor_completed) begin

					if(regs_idx != 0 && regs_idx == out_reg_num && out_general_reg)
						general_regs[out_reg_num] <= exec_reg_out;
					if(regs_idx == out_reg_num && out_float_reg)
						float_regs[out_reg_num] <= exec_reg_out;

				end

			end

		end
	endgenerate

endmodule
