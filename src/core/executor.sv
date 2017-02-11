`timescale 1ps / 100fs

module Executor(

	input logic clk,
	input logic reset,
	output logic completed,
	output logic halted,

	input logic[31:0] pc,
	input logic[5:0] inst_num,
	input logic[15:0] const16,
	input logic[4:0] shift5,
	input logic[25:0] addr26,
	input logic[31:0] float_in_regs [3],
	input logic[31:0] general_in_regs [3],

	output logic[31:0] exec_reg_out,
	output logic[31:0] exec_pc_out,

	output logic[31:0] main_mem_in_addr,
	output logic[31:0] main_mem_in_data,
	output logic main_mem_in_valid,
	input logic main_mem_in_ready,
	output logic[31:0] main_mem_out_addr,
	output logic main_mem_out_valid,
	input logic[31:0] main_mem_out_data,
	input logic main_mem_out_ready,

	output logic[7:0] uart_in_data,
	output logic uart_in_valid,
	input logic uart_in_ready,
	output logic uart_out_valid,
	input logic[7:0] uart_out_data,
	input logic uart_out_ready

	);

	logic[31:0] rs, rt, rd, fs, ft, fd;

	logic cat_misc, cat_addsub, cat_muldiv,
		cat_bit, cat_mem, cat_branch, cat_fpu_mem, cat_fpu_alu;

	logic elem_reset [5];
	logic elem_completed [5];
	logic[31:0] elem_exec_reg_out [5];
	logic[31:0] branch_exec_pc_out;

	logic[31:0] const16_x;

	MiscExecElement misc_exec_elem(
		.reset(elem_reset[0]), .completed(elem_completed[0]),
		.out(elem_exec_reg_out[0]), .halted(halted), .*);

	AluExecElement alu_exec_elem(
		.reset(elem_reset[1]), .completed(elem_completed[1]),
		.out(elem_exec_reg_out[1]), .*);

	FpuAluExecElement fpu_alu_exec_elem(
		.reset(elem_reset[2]), .completed(elem_completed[2]),
		.out(elem_exec_reg_out[2]),  .*);

	MemExecElement mem_exec_elem(
		.reset(elem_reset[3]), .completed(elem_completed[3]),
		.out(elem_exec_reg_out[3]),  .*);

	BranchExecElement branch_exec_elem(
		.reset(elem_reset[4]), .completed(elem_completed[4]),
		.reg_out(elem_exec_reg_out[4]), .pc_out(branch_exec_pc_out), .*);

	genvar e_i;
	generate
		for(e_i = 16; e_i < 32; e_i = e_i + 1) begin: Const16XWiring

			always_comb begin

				const16_x[e_i] = const16[15];
				const16_x[15:0] = const16;

			end

		end
	endgenerate

	always_comb begin

		rs = general_in_regs[0];
		rt = general_in_regs[1];
		rd = general_in_regs[2];
		fs = float_in_regs[0];
		ft = float_in_regs[1];
		fd = float_in_regs[2];

		cat_misc = (inst_num >= 4 && inst_num < 8);
		cat_addsub = (inst_num >= 8 && inst_num < 12);
		cat_muldiv = (inst_num >= 12 && inst_num < 16);
		cat_bit = (inst_num >= 16 && inst_num < 28);
		cat_mem = (inst_num >= 28 && inst_num < 32);
		cat_branch = (inst_num >= 32 && inst_num < 48);
		cat_fpu_mem = (inst_num >= 48 && inst_num < 54);
		cat_fpu_alu = (inst_num >= 54 && inst_num < 64);

		elem_reset[0] = reset || !(cat_misc);
		elem_reset[1] = reset || !(cat_addsub || cat_muldiv || cat_bit);
		elem_reset[2] = reset || !(cat_fpu_alu);
		elem_reset[3] = reset || !(cat_mem || cat_fpu_mem);
		elem_reset[4] = reset || !(cat_branch);

		completed = elem_completed[0] || elem_completed[1] ||
			elem_completed[2] || elem_completed[3] || elem_completed[4];

		if(elem_reset[4])
			exec_pc_out = pc + 4;
		else
			exec_pc_out = branch_exec_pc_out;

		if(!elem_reset[0])
			exec_reg_out = elem_exec_reg_out[0];
		else if(!elem_reset[1])
			exec_reg_out = elem_exec_reg_out[1];
		else if(!elem_reset[2])
			exec_reg_out = elem_exec_reg_out[2];
		else if(!elem_reset[3])
			exec_reg_out = elem_exec_reg_out[3];
		else
			exec_reg_out = elem_exec_reg_out[4];

	end

endmodule
