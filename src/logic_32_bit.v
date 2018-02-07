// Name: logic_32_bit.v
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

// 32-bit NOR
module NOR32_2x1(Y, A, B);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	input [31:0] B;
	
	// TBD
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: nor_gen_loop
			nor nor_inst(Y[i], A[i], B[i]);
		end
	endgenerate
	
endmodule

// 32-bit AND
module AND32_2x1(Y, A, B);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	input [31:0] B;
	
	// TBD
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: and_gen_loop
			and and_inst(Y[i], A[i], B[i]);
		end
	endgenerate
	
endmodule

// 64-bit inverter
module NOT64_1x1(Y, A);
	// output list
	output [63:0] Y;
	
	// input list
	input [63:0] A;

	genvar i;
	generate
		for (i = 0; i <= 63; i = i + 1) begin: not_gen_loop
			not not_inst(Y[i], A[i]);
		end
	endgenerate
	
endmodule

// 32-bit inverter
module NOT32_1x1(Y, A);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	
	// TBD
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: not_gen_loop
			not not_inst(Y[i], A[i]);
		end
	endgenerate
	
endmodule

// 32-bit buffer
module BUF32_1x1(Y, A);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	
	// TBD
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: buf_gen_loop
			buf buf_inst(Y[i], A[i]);
		end
	endgenerate
	
endmodule

// 32-bit OR
module OR32_2x1(Y, A, B);
	//output 
	output [31:0] Y;
	//input
	input [31:0] A;
	input [31:0] B;
	
	// TBD
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: or_gen_loop
			or or_inst(Y[i], A[i], B[i]);
		end
	endgenerate
	
endmodule
