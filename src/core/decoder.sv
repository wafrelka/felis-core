module Decoder(

	input logic[31:0] instruction,

	output logic[5:0] inst_num,
	output logic[15:0] const16,
	output logic[4:0] shift5,
	output logic[25:0] addr26,
	output logic[4:0] in_reg_num [3],
	output logic[4:0] out_reg_num,
	output logic out_general_reg,
	output logic out_float_reg,

	);

	logic cat_misc;
	logic cat_addsub;
	logic cat_muldiv;
	logic cat_bit;
	logic cat_mem;
	logic cat_branch;
	logic cat_fpu_mem;
	logic cat_fpu_alu;

	always_comb begin

		inst_num[5:0] = instruction[31:26];
		in_reg_num[0][4:0] = instruction[25:21];
		in_reg_num[1][4:0] = instruction[20:16];
		in_reg_num[2][4:0] = instruction[15:11];
		shift5[4:0] = instruction[10:6];
		const16[15:0] = instruction[15:0];
		addr26[25:0] = instruction[25:0];

		cat_misc = (inst_num >= 4 && inst_num < 8);
		cat_addsub = (inst_num >= 8 && inst_num < 12);
		cat_muldiv = (inst_num >= 12 && inst_num < 14);
		cat_bit = (inst_num >= 16 && inst_num < 28);
		cat_mem = (inst_num >= 28 && inst_num < 32);
		cat_branch = (inst_num >= 32 && inst_num < 48);
		cat_fpu_mem = (inst_num >= 48 && inst_num < 54);
		cat_fpu_alu = (inst_num >= 54 && inst_num < 64);

	end

	always_comb begin

		case(inst_num)

			9, 11, 21, 23, 25, 28, 42, 48, 52, 53, 54, 55, 60, 61, 62:
				out_reg_num = in_reg_num[1];

			37, 38, 40:
				out_reg_num = 31;

			default:
				out_reg_num = in_reg_num[2];

		endcase

		case(inst_num)

			6, 28, 29, 37, 38, 40, 42, 53:
				out_general_reg = 1;

			default:
				out_general_reg = (cat_addsub || cat_muldiv || cat_bit);

		endcase

		case(inst_num)

			48, 49, 52:
				out_float_reg = 1;

			default:
				out_float_reg = cat_fpu_alu;

		endcase

	end

endmodule
