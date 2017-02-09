`timescale 1ps / 100fs

module Core(

	input logic clk,
	input logic reset,

	output logic[31:0] inst_mem_out_addr,
	output logic inst_mem_out_valid,
	input logic[31:0] inst_mem_out_data,
	input logic inst_mem_out_ready,

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

	logic fetcher_reset;
	logic fetcher_completed;
	logic[31:0] pc;
	logic[31:0] instruction;

	logic executor_reset;
	logic executor_completed;
	logic[5:0] inst_num;
	logic[15:0] const16;
	logic[4:0] shift5;
	logic[25:0] addr26;
	logic[31:0] float_in_regs [3];
	logic[31:0] general_in_regs [3];
	logic[31:0] exec_reg_out;
	logic[31:0] exec_pc_out;

	CoreController core_controller(.*);
	Fetcher fetcher(.reset(fetcher_reset), .completed(fetcher_completed), .*);
	Executor executor(.reset(executor_reset), .completed(executor_completed), .*);

endmodule
