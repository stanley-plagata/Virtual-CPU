// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y, D, S, LnR);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [31:0] S;
	input LnR;
	
	// TBD
	wire [31:0] BS;
	wire or_S;
	
	BARREL_SHIFTER32 bs_inst(.Y(BS), .D(D), .S(S[4:0]), .LnR(LnR));
	
	or or_inst(or_S, S[5], S[6], S[7],
			S[8], S[9], S[10], S[11],
			S[12], S[13], S[14], S[15],
			S[16], S[17], S[18], S[19],
			S[20], S[21], S[22], S[23],
			S[24], S[25], S[26], S[27],
			S[28], S[29], S[30], S[31]);
	
	//OR32 or_inst(.Y(or_S), .A({5'b0, {S[31:5]}}), .B());
	
	MUX32_2x1 mux_inst(.Y(Y), .I0(BS), .I1(32'b0), .S(or_S));
	
endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y, D, S, LnR);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [4:0] S;
	input LnR;
	
	// TBD
	wire [31:0] D_shift_R, D_shift_L;
	
	SHIFT32_R shift_R_inst(.Y(D_shift_R), .D(D), .S(S));
	SHIFT32_L shift_L_inst(.Y(D_shift_L), .D(D), .S(S));
	
	MUX32_2x1 mux_inst(.Y(Y), .I0(D_shift_R), .I1(D_shift_L), .S(LnR));

endmodule

// Right shifter
module SHIFT32_R(Y, D, S);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [4:0] S;
	
	// TBD
	wire [31:0] mux_D_stage_1, mux_D_stage_2, mux_D_stage_3, mux_D_stage_4;
	
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: shift32_R_gen_loop_1
			if (i < 31) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_1[i]),
						.I0(D[i]), .I1(D[i+1]), .S(S[0]));
			end
			else if (i == 31) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_1[i]),
						.I0(D[i]), .I1(1'b0), .S(S[0]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_R_gen_loop_2
			if (i < 30) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_2[i]),
						.I0(mux_D_stage_1[i]), .I1(mux_D_stage_1[i+2]), .S(S[1]));
			end
			else if (i >= 30) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_2[i]),
						.I0(mux_D_stage_1[i]), .I1(1'b0), .S(S[1]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_R_gen_loop_3
			if (i < 28) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_3[i]),
						.I0(mux_D_stage_2[i]), .I1(mux_D_stage_2[i+4]), .S(S[2]));
			end
			else if (i >= 28) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_3[i]),
						.I0(mux_D_stage_2[i]), .I1(1'b0), .S(S[2]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_R_gen_loop_4
			if (i < 24) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_4[i]),
						.I0(mux_D_stage_3[i]), .I1(mux_D_stage_3[i+8]), .S(S[3]));
			end
			else if (i >= 24) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_4[i]),
						.I0(mux_D_stage_3[i]), .I1(1'b0), .S(S[3]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_R_gen_loop_5
			if (i < 16) begin
				MUX1_2x1 mux_inst(.Y(Y[i]),
						.I0(mux_D_stage_4[i]), .I1(mux_D_stage_4[i+16]), .S(S[4]));
			end
			else if (i >= 16) begin
				MUX1_2x1 mux_inst(.Y(Y[i]),
						.I0(mux_D_stage_4[i]), .I1(1'b0), .S(S[4]));
			end
		end
	endgenerate
	
endmodule

// Left shifter
module SHIFT32_L(Y, D, S);
	// output list
	output [31:0] Y;
	// input list
	input [31:0] D;
	input [4:0] S;
	
	// TBD
	wire [31:0] mux_D_stage_1, mux_D_stage_2, mux_D_stage_3, mux_D_stage_4;
	
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: shift32_L_gen_loop_1
			if (i < 1) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_1[i]),
						.I0(D[i]), .I1(1'b0), .S(S[0]));
			end
			else if (i >= 1) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_1[i]),
						.I0(D[i]), .I1(D[i-1]), .S(S[0]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_L_gen_loop_2
			if (i < 2) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_2[i]),
						.I0(mux_D_stage_1[i]), .I1(1'b0), .S(S[1]));
			end
			else if (i >= 2) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_2[i]),
						.I0(mux_D_stage_1[i]), .I1(mux_D_stage_1[i-2]), .S(S[1]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_L_gen_loop_3
			if (i < 4) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_3[i]),
						.I0(mux_D_stage_2[i]), .I1(1'b0), .S(S[2]));
			end
			else if (i >= 4) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_3[i]),
						.I0(mux_D_stage_2[i]), .I1(mux_D_stage_2[i-4]), .S(S[2]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_L_gen_loop_4
			if (i < 8) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_4[i]),
						.I0(mux_D_stage_3[i]), .I1(1'b0), .S(S[3]));
			end
			else if (i >= 8) begin
				MUX1_2x1 mux_inst(.Y(mux_D_stage_4[i]),
						.I0(mux_D_stage_3[i]), .I1(mux_D_stage_3[i-8]), .S(S[3]));
			end
		end
		
		for (i = 0; i <= 31; i = i + 1) begin: shift32_L_gen_loop_5
			if (i < 16) begin
				MUX1_2x1 mux_inst(.Y(Y[i]),
						.I0(mux_D_stage_4[i]), .I1(1'b0), .S(S[4]));
			end
			else if (i >= 16) begin
				MUX1_2x1 mux_inst(.Y(Y[i]),
						.I0(mux_D_stage_4[i]), .I1(mux_D_stage_4[i-16]), .S(S[4]));
			end
		end
	endgenerate
	
endmodule
