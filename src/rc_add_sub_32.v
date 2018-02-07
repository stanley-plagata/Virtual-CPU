// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
	// output list
	output [63:0] Y;
	output CO;
	// input list
	input [63:0] A;
	input [63:0] B;
	input SnA;

	// TBD
	wire [63:0] xor_B;
	wire [63:0] CI;
	
	genvar i;
	generate
		for (i = 0; i <= 63; i = i + 1) begin: rc_64_gen_loop
			xor xor_inst(xor_B[i], SnA, B[i]);
			if (i == 0) begin
				FULL_ADDER fs_inst(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(xor_B[i]), .CI(SnA));
			end
			else if ((i > 0) && (i < 63)) begin
				FULL_ADDER fs_inst(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(xor_B[i]), .CI(CI[i - 1]));
			end
			else if (i == 63) begin
				FULL_ADDER fs_inst(.S(Y[i]), .CO(CO), .A(A[i]), .B(xor_B[i]), .CI(CI[i - 1]));
			end
		end	
	endgenerate
endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
	// output list
	output [`DATA_INDEX_LIMIT:0] Y;
	output CO;
	// input list
	input [`DATA_INDEX_LIMIT:0] A;
	input [`DATA_INDEX_LIMIT:0] B;
	input SnA;

	// TBD
	wire [`DATA_INDEX_LIMIT:0] xor_B;
	wire [`DATA_INDEX_LIMIT:0] CI;
	
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: rc_32_gen_loop
			xor xor_inst(xor_B[i], SnA, B[i]);
			if (i == 0) begin
				FULL_ADDER fs_inst(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(xor_B[i]), .CI(SnA));
			end
			else if ((i > 0) && (i < 31)) begin
				FULL_ADDER fs_inst(.S(Y[i]), .CO(CI[i]), .A(A[i]), .B(xor_B[i]), .CI(CI[i - 1]));
			end
			else if (i == 31) begin
				FULL_ADDER fs_inst(.S(Y[i]), .CO(CO), .A(A[i]), .B(xor_B[i]), .CI(CI[i - 1]));
			end
		end	
	endgenerate
endmodule
