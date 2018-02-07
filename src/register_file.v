// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be -ve edge clock triggered register file.
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2,
						   DATA_W, ADDR_W, READ, WRITE, CLK, RST);
	// input list
	input READ, WRITE, CLK, RST;
	input [`DATA_INDEX_LIMIT:0] DATA_W;
	input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

	// output list
	output [`DATA_INDEX_LIMIT:0] DATA_R1;
	output [`DATA_INDEX_LIMIT:0] DATA_R2;
	
	//TBD
	wire [31:0] buf_dc, and_D, buf_R1, buf_R2;
	wire [31:0] buf_reg [31:0];
	//wire not_RST;
	
	DECODER_5x32 dc_inst(.D(buf_dc), .I(ADDR_W));
	//not not_inst(not_RST, RST);
	
	genvar i;
	generate
		for (i = 0; i <= 31; i = i + 1) begin: reg_gen_loop
			and and_inst(and_D[i], buf_dc[i], WRITE);
			REG32_PP reg_inst(.Q(buf_reg[i]), .D(DATA_W),
						   .LOAD(and_D[i]), .CLK(CLK), .RESET(RST));
		end
	endgenerate
	
	MUX32_32x1 mux_inst_1(.Y(buf_R1), .I0(buf_reg[0]), .I1(buf_reg[1]),
						  .I2(buf_reg[2]), .I3(buf_reg[3]), .I4(buf_reg[4]),
						  .I5(buf_reg[5]), .I6(buf_reg[6]), .I7(buf_reg[7]),
						  .I8(buf_reg[8]), .I9(buf_reg[9]), .I10(buf_reg[10]),
						  .I11(buf_reg[11]), .I12(buf_reg[12]), .I13(buf_reg[13]),
						  .I14(buf_reg[14]), .I15(buf_reg[15]), .I16(buf_reg[16]),
						  .I17(buf_reg[17]), .I18(buf_reg[18]), .I19(buf_reg[19]),
						  .I20(buf_reg[20]), .I21(buf_reg[21]), .I22(buf_reg[22]),
						  .I23(buf_reg[23]), .I24(buf_reg[24]), .I25(buf_reg[25]),
						  .I26(buf_reg[26]), .I27(buf_reg[27]), .I28(buf_reg[28]),
						  .I29(buf_reg[29]), .I30(buf_reg[30]), .I31(buf_reg[31]),
						  .S(ADDR_R1));
	
	MUX32_32x1 mux_inst_2(.Y(buf_R2), .I0(buf_reg[0]), .I1(buf_reg[1]),
						  .I2(buf_reg[2]), .I3(buf_reg[3]), .I4(buf_reg[4]),
						  .I5(buf_reg[5]), .I6(buf_reg[6]), .I7(buf_reg[7]),
						  .I8(buf_reg[8]), .I9(buf_reg[9]), .I10(buf_reg[10]),
						  .I11(buf_reg[11]), .I12(buf_reg[12]), .I13(buf_reg[13]),
						  .I14(buf_reg[14]), .I15(buf_reg[15]), .I16(buf_reg[16]),
						  .I17(buf_reg[17]), .I18(buf_reg[18]), .I19(buf_reg[19]),
						  .I20(buf_reg[20]), .I21(buf_reg[21]), .I22(buf_reg[22]),
						  .I23(buf_reg[23]), .I24(buf_reg[24]), .I25(buf_reg[25]),
						  .I26(buf_reg[26]), .I27(buf_reg[27]), .I28(buf_reg[28]),
						  .I29(buf_reg[29]), .I30(buf_reg[30]), .I31(buf_reg[31]),
						  .S(ADDR_R2));
	
	MUX32_2x1 mux_inst_3(.Y(DATA_R1), .I0(32'bZ), .I1(buf_R1), .S(READ));
	MUX32_2x1 mux_inst_4(.Y(DATA_R2), .I0(32'bZ), .I1(buf_R2), .S(READ));
	
endmodule
