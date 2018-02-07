// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
	// input list
	input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
	input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
	input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

	// output list
	output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
	output ZERO;

	// TBD
	wire inv_OPRN, and_OPRN, or_OPRN;
	wire [31:0] add_sub_OP, mul_OP_LO, mul_OP_HI, shift_OP, and_OP, or_OP, nor_OP, set_less_than_OP, mux_OP;
	wire buf_null;
	
	not inv_inst(inv_OPRN, OPRN[0]);
	and and_inst(and_OPRN, OPRN[0], OPRN[3]);
	or or_inst(or_OPRN, inv_OPRN, and_OPRN);
	
	RC_ADD_SUB_32 rc_inst(.Y(add_sub_OP), .CO(buf_null), .A(OP1), .B(OP2), .SnA(or_OPRN));
	MULT32 mult_inst(.HI(mul_OP_HI), .LO(mul_OP_LO), .A(OP1), .B(OP2));
	SHIFT32 bs_inst(.Y(shift_OP), .D(OP1), .S(OP2), .LnR(OPRN));
	AND32_2x1 and32_inst(.Y(and_OP), .A(OP1), .B(OP2));
	OR32_2x1 or32_inst(.Y(or_OP), .A(OP1), .B(OP2));
	NOR32_2x1 nor32_inst_1(.Y(nor_OP), .A(OP1), .B(OP2));
	BUF32_1x1 buf32_inst(.Y(set_less_than_OP), .A({{31'b0},{add_sub_OP[31]}}));
	
	MUX32_16x1 mux_inst(.Y(mux_OP), .I0(32'b0), .I1(add_sub_OP), .I2(add_sub_OP), .I3(mul_OP_LO),
									.I4(shift_OP), .I5(shift_OP), .I6(and_OP), .I7(or_OP),
									.I8(nor_OP), .I9(set_less_than_OP), .I10(32'b0), .I11(32'b0),
									.I12(32'b0), .I13(32'b0), .I14(32'b0), .I15(32'b0),
									.S(OPRN));
	
	nor nor_inst(ZERO, mux_OP[0], mux_OP[1], mux_OP[2], mux_OP[3],
					   mux_OP[4], mux_OP[5], mux_OP[6], mux_OP[7],
					   mux_OP[8], mux_OP[9], mux_OP[10], mux_OP[11],
					   mux_OP[12], mux_OP[13], mux_OP[14], mux_OP[15],
					   mux_OP[16], mux_OP[17], mux_OP[18], mux_OP[19],
					   mux_OP[20], mux_OP[21], mux_OP[22], mux_OP[23],
					   mux_OP[24], mux_OP[25], mux_OP[26], mux_OP[27],
					   mux_OP[28], mux_OP[29], mux_OP[30], mux_OP[31]);
	
	BUF32_1x1 buf_inst(OUT, mux_OP);
	
	/*
	genvar i;
	generate
		for (i = 0; i < 31; i = i + 1) begin: nor_gen_loop
			nor nor_inst(somewire[i], mux_OP[i], 1'b0);
		end
	endgenerate
	nor nor_inst(ZERO, );
	*/
	//NOR32_2x1 nor32_inst_2(.Y(ZERO), .A(mux_OP), .B(32'b0));
	
	/*
	reg[`DATA_INDEX_LIMIT:0] OUT;
	reg[`DATA_INDEX_LIMIT:0] ZERO;

	always @(OP1 or OP2 or OPRN) begin
		case (OPRN)
			`ALU_OPRN_WIDTH'h01: OUT = OP1 + OP2;		// addition
			`ALU_OPRN_WIDTH'h02: OUT = OP1 - OP2;		// subtraction
			`ALU_OPRN_WIDTH'h03: OUT = OP1 * OP2;		// multiplication
			`ALU_OPRN_WIDTH'h04: OUT = OP1 >> OP2;		// shift_right_logical
			`ALU_OPRN_WIDTH'h05: OUT = OP1 << OP2;		// shift_left_logical
			`ALU_OPRN_WIDTH'h06: OUT = OP1 & OP2;		// logical AND
			`ALU_OPRN_WIDTH'h07: OUT = OP1 | OP2;		// logical OR
			`ALU_OPRN_WIDTH'h08: OUT = ~(OP1 | OP2);	// logical NOR
			`ALU_OPRN_WIDTH'h09: OUT = OP1 < OP2;		// set_less_than
			default: OUT = `DATA_WIDTH'hxxxxxxxx;
		endcase
		ZERO = (OUT === 1'b0)? 1 : 0;
	end
	*/
endmodule
