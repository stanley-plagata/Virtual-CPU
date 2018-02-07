// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
	// output list
	output [31:0] HI;
	output [31:0] LO;
	// input list
	input [31:0] A;
	input [31:0] B;

	// TBD
	wire [31:0] twoscomp_A, mux_A, twoscomp_B, mux_B;
	wire [63:0] uP, twoscomp_uP, P;
	wire A_xor_B;
	
	TWOSCOMP32 twoscomp32_inst_1(twoscomp_A, A);
	MUX32_2x1 mux_inst_1(.Y(mux_A), .I0(A), .I1(twoscomp_A), .S(A[31]));
	TWOSCOMP32 twoscomp32_inst_2(twoscomp_B, B);
	MUX32_2x1 mux_inst_2(.Y(mux_B), .I0(B), .I1(twoscomp_B), .S(B[31]));
	
	MULT32_U mult_u_inst(.HI(uP[63:32]), .LO(uP[31:0]), .A(mux_A), .B(mux_B));
	
	TWOSCOMP64 twoscomp64_inst(twoscomp_uP, uP);
	xor xor_inst(A_xor_B, A[31], B[31]);
	MUX64_2x1 mux_inst_3(.Y(P), .I0(uP), .I1(twoscomp_uP), .S(A_xor_B));
	
	BUF32_1x1 buf32_inst_1(.Y(HI), .A(P[63:32]));
	BUF32_1x1 buf32_inst_2(.Y(LO), .A(P[31:0]));
	
endmodule

module MULT32_U(HI, LO, A, B);
	// output list
	output [31:0] HI;
	output [31:0] LO;
	// input list
	input [31:0] A;
	input [31:0] B;

	// TBD
	wire [31:0] CO;
	wire [31:0] S [31:0];
	
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: mult32_gen_loop
			wire [31:0] and_M;
			if (i == 0) begin
				AND32_2x1 and32_inst(.Y(and_M), .A(A), .B({32{B[i]}}));
				BUF32_1x1 buf32_inst(.Y(S[0]), .A(and_M));
				buf buf_inst_1(CO[i], 1'b0);
				buf buf_inst_2(LO[i], S[i][0]);
			end
			else if (i > 0) begin
				AND32_2x1 and32_inst(.Y(and_M), .A(A), .B({32{B[i]}}));
				RC_ADD_SUB_32 rc32_inst (.Y(S[i]), .CO(CO[i]),
						.A(and_M), .B({{CO[i-1]}, {S[i-1][31:1]}}), .SnA(1'b0));
				buf buf_inst(LO[i], S[i][0]);
			end
		end
	endgenerate
	BUF32_1x1 buf32_inst(.Y(HI), .A({{CO[31]}, {S[31][31:1]}}));
	
endmodule
