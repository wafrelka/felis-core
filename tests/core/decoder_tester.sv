`timescale 1ns / 100ps

module DecoderTester();

	logic[31:0] instruction;
	logic[5:0] inst;

	logic[5:0] inst_num;
	logic[15:0] const16;
	logic[4:0] shift5;
	logic[25:0] addr26;
	logic[4:0] in_reg_num[3];
	logic[4:0] onum;
	logic outg, outf;

	localparam logic[4:0] rs = 5'b00110;
	localparam logic[4:0] rt = 5'b11000;
	localparam logic[4:0] rd = 5'b10101;

	Decoder decoder(.out_general_reg(ogen), .out_float_reg(oflt),
		.out_reg_num(onum), .*);

	task check_none();
		#10;
		assert(!ogen && !oflt);
	endtask

	task check_rt();
		#10;
		assert(ogen && !oflt && onum == rt);
	endtask

	task check_rd();
		#10;
		assert(ogen && !oflt && onum == rd);
	endtask

	task check_ra();
		#10;
		assert(ogen && !oflt && onum == 31);
	endtask

	task check_ft();
		#10;
		assert(!ogen && oflt && onum == rt);
	endtask

	task check_fd();
		#10;
		assert(!ogen && oflt && onum == rd);
	endtask

	always_comb begin
		instruction = {inst[5:0], rs, rt, rd, 11'b11100111001};
	end

	initial begin

		inst =  4; check_none();
		inst =  5; check_none();
		inst =  6; check_rd();
		inst =  7; check_none();

		inst =  8; check_rd();
		inst =  9; check_rt();
		inst = 10; check_rd();
		inst = 11; check_rt();

		inst = 12; check_rd();
		inst = 13; check_rd();
		inst = 14; check_rt();
		inst = 15; check_rt();

		inst = 16; check_rd();
		inst = 17; check_rd();
		inst = 18; check_rd();
		inst = 20; check_rd();
		inst = 21; check_rt();
		inst = 22; check_rd();
		inst = 23; check_rt();
		inst = 24; check_rd();
		inst = 25; check_rt();
		inst = 26; check_rd();

		inst = 28; check_rt();
		inst = 29; check_rd();
		inst = 30; check_none();
		inst = 31; check_none();

		inst = 32; check_none();
		inst = 33; check_none();
		inst = 34; check_none();
		inst = 35; check_none();
		inst = 36; check_none();
		inst = 37; check_ra();
		inst = 38; check_ra();
		inst = 39; check_none();
		inst = 40; check_ra();
		inst = 41; check_none();
		inst = 42; check_rt();

		inst = 48; check_ft();
		inst = 49; check_fd();
		inst = 50; check_none();
		inst = 51; check_none();
		inst = 52; check_ft();
		inst = 53; check_rt();

		inst = 54; check_ft();
		inst = 55; check_ft();
		inst = 56; check_fd();
		inst = 57; check_fd();
		inst = 58; check_fd();
		inst = 59; check_fd();
		inst = 60; check_ft();
		inst = 61; check_ft();
		inst = 62; check_ft();
		inst = 63; check_ft();

		$finish();

	end

endmodule
