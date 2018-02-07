// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S, CO, A, B, CI);
	output S, CO;
	input A, B, CI;

	//TBD
	wire Y, C1, C2;
	
	HALF_ADDER hs_inst_1(.Y(Y), .C(C1), .A(A), .B(B));
	HALF_ADDER hs_inst_2(.Y(S), .C(C2), .A(Y), .B(CI));
	or or_inst(CO, C1, C2);
endmodule
