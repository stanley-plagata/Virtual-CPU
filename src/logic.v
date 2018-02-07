// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y, A);
	//output list
	output [63:0] Y;
	//input list
	input [63:0] A;
	
	// TBD
	reg [63:0] B = 64'b1;
	
	wire [63:0] not_A;
	wire buf_null;
	
	NOT64_1x1 not_inst(not_A, A);
	RC_ADD_SUB_64 fs_inst(.Y(Y), .CO(buf_null), .A(not_A), .B(B), .SnA(1'b0));

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y, A);
	//output list
	output [31:0] Y;
	//input list
	input [31:0] A;
	
	// TBD
	reg [31:0] B = 32'b1;
	
	wire [31:0] not_A;
	wire buf_null;
	
	NOT32_1x1 not_inst(not_A, A);
	RC_ADD_SUB_32 fs_inst(.Y(Y), .CO(buf_null), .A(not_A), .B(B), .SnA(1'b0));

endmodule

// 32-bit register -ve edge
module REG32_PP(Q, D, LOAD, CLK, RESET);
	parameter PATTERN = 32'h00000000;
	output [31:0] Q;
	
	input CLK, LOAD;
	input [31:0] D;
	input RESET;
	
	// TBD
	wire [31:0] buf_Qbar;
	
	genvar i;
	generate 
		for(i = 0; i <= 31; i = i + 1) begin : reg32_pp_gen_loop
			if (PATTERN[i] == 0) begin
				REG1 reg_inst(.Q(Q[i]), .Qbar(buf_Qbar[i]), .D(D[i]),
						.L(LOAD), .nC(CLK), .nP(1'b1), .nR(RESET)); 
			end
			else begin
				REG1 reg_inst(.Q(Q[i]), .Qbar(buf_Qbar[i]), .D(D[i]),
						.L(LOAD), .nC(CLK), .nP(RESET), .nR(1'b1));
			end
		end 
	endgenerate

endmodule

// 1 bit register -ve edge
module REG1(Q, Qbar, D, L, nC, nP, nR);
	input D, nC, L;
	input nP, nR;
	output Q, Qbar;
	
	// TBD
	wire mux_D;
	
	MUX1_2x1 mux_inst(.Y(mux_D), .I0(Q), .I1(D), .S(L));
	D_FF dff_inst(.Q(Q), .Qbar(Qbar), .D(mux_D), .nC(nC), .nP(nP), .nR(nR));

endmodule

// 1 bit D F/F -ve edge
module D_FF(Q, Qbar, D, nC, nP, nR);
	input D, nC;
	input nP, nR;
	output Q, Qbar;
	
	// TBD
	wire buf_Y, buf_Ybar, not_nC;
	
	not not_inst(not_nC, nC);
	D_LATCH d_latch_inst(.Q(buf_Y), .Qbar(buf_Ybar), .D(D), .C(not_nC), .nP(nP), .nR(nR));
	SR_LATCH sr_latch_inst(.Q(Q), .Qbar(Qbar), .S(buf_Y), .R(buf_Ybar), .C(nC), .nP(nP), .nR(nR));

endmodule

// 1 bit D latch
module D_LATCH(Q, Qbar, D, C, nP, nR);
	input D, C;
	input nP, nR;
	output Q, Qbar;
	
	// TBD
	wire not_D;
	
	not not_inst(not_D, D);
	SR_LATCH sr_latch_inst(.Q(Q), .Qbar(Qbar), .S(D), .R(not_D), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit SR latch
module SR_LATCH(Q, Qbar, S, R, C, nP, nR);
	input S, R, C;
	input nP, nR;
	output Q, Qbar;
	
	// TBD
	wire [1:0] nand_S, nand_R;
	
	nand nand_inst_1(nand_S[0], S, C);
	nand nand_inst_2(nand_R[0], R, C);
	
	nand nand_inst_3(nand_S[1], nand_S[0], nand_R[1], nP);
	nand nand_inst_4(nand_R[1], nand_R[0], nand_S[1], nR);
	
	buf buf_inst_1(Q, nand_S[1]);
	buf buf_inst_2(Qbar, nand_R[1]);

endmodule

// 5x32 Line decoder
module DECODER_5x32(D, I);
	// output
	output [31:0] D;
	// input
	input [4:0] I;
	
	// TBD
	wire [15:0] buf_dc;
	wire not_I4;
	
	DECODER_4x16 dc_inst_1(.D(buf_dc), .I(I[3:0]));
	not not_inst(not_I4, I[4]);
	
	genvar i;
	generate
		for (i = 0; i <= 15; i = i + 1) begin: dc_5x32_gen_loop
			and and_inst_1(D[i], buf_dc[i], not_I4);
			and and_inst_2(D[i+16], buf_dc[i], I[4]);
		end
	endgenerate

endmodule

// 4x16 Line decoder
module DECODER_4x16(D, I);
	// output
	output [15:0] D;
	// input
	input [3:0] I;
	
	// TBD
	wire [7:0] buf_dc;
	wire not_I3;
	
	DECODER_3x8 dc_inst_1(.D(buf_dc), .I(I[2:0]));
	not not_inst(not_I3, I[3]);
	
	genvar i;
	generate
		for (i = 0; i <= 7; i = i + 1) begin: dc_4x16_gen_loop
			and and_inst_1(D[i], buf_dc[i], not_I3);
			and and_inst_2(D[i+8], buf_dc[i], I[3]);
		end
	endgenerate

endmodule

// 3x8 Line decoder
module DECODER_3x8(D, I);
	// output
	output [7:0] D;
	// input
	input [2:0] I;
	
	//TBD
	wire [3:0] buf_dc;
	wire not_I3;
	
	DECODER_2x4 dc_inst_1(.D(buf_dc), .I(I[1:0]));
	not not_inst(not_I2, I[2]);
	
	genvar i;
	generate
		for (i = 0; i <= 3; i = i + 1) begin: dc_3x8_gen_loop
			and and_inst_1(D[i], buf_dc[i], not_I2);
			and and_inst_2(D[i+4], buf_dc[i], I[2]);
		end
	endgenerate

endmodule

// 2x4 Line decoder
module DECODER_2x4(D, I);
	// output
	output [3:0] D;
	// input
	input [1:0] I;
	
	// TBD
	wire not_I0, not_I1;
	
	not not_inst_1(not_I0, I[0]);
	not not_inst_2(not_I1, I[1]);
	
	and and_inst_1(D[0], not_I1, not_I0);
	and and_inst_2(D[1], not_I1, I[0]);
	and and_inst_3(D[2], I[1], not_I0);
	and and_inst_4(D[3], I[1], I[0]);

endmodule