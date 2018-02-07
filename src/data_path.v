// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);
	// output list
	output [`ADDRESS_INDEX_LIMIT:0] ADDR;
	output ZERO;
	output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;
	
	// input list
	input [`CTRL_WIDTH_INDEX_LIMIT:0] CTRL;
	input CLK, RST;
	input [`DATA_INDEX_LIMIT:0] DATA_IN;
	
	// TBD
	wire [31:0] buf_pc, rc_1_pc_load, rc_2_pc_load, buf_ir,
			mux_wd_sel_1, mux_wd_sel_2, mux_wd_sel_3, buf_r1_data, buf_r2_data, buf_sp,
			mux_op1_sel_1, mux_op2_sel_1, mux_op2_sel_2, mux_op2_sel_3, mux_op2_sel_4,
			alu_result, mux_ma_sel_1, mux_ma_sel_2, mux_md_sel_1,
			mux_pc_sel_1, mux_pc_sel_2, mux_pc_sel_3;
	wire [4:0] mux_r1_sel_1, mux_wa_sel_1, mux_wa_sel_2, mux_wa_sel_3;
	wire buf_null;
	
	defparam pc_inst.PATTERN = `INST_START_ADDR;
	REG32_PP pc_inst(.Q(buf_pc), .D(mux_pc_sel_3), .LOAD(CTRL[0]), .CLK(CLK), .RESET(RST));
	
	RC_ADD_SUB_32 rc_inst_1(.Y(rc_1_pc_load), .CO(buf_null),
			.A(buf_pc), .B(32'b1), .SnA(1'b0));
	RC_ADD_SUB_32 rc_inst_2(.Y(rc_2_pc_load), .CO(buf_null),
			.A({{16{buf_ir[15]}}, buf_ir[15:0]}), .B(rc_1_pc_load), .SnA(1'b0));
			
	MUX32_2x1 mux_pc_inst_1(.Y(mux_pc_sel_1),
			.I0(buf_r1_data), .I1(rc_1_pc_load), .S(CTRL[1]));
	MUX32_2x1 mux_pc_inst_2(.Y(mux_pc_sel_2),
			.I0(mux_pc_sel_1), .I1(rc_2_pc_load), .S(CTRL[2]));
	MUX32_2x1 mux_pc_inst_3(.Y(mux_pc_sel_3),
			.I0({{6'b0}, {buf_ir[25:0]}}), .I1(mux_pc_sel_2), .S(CTRL[3]));
	
	defparam ir_inst.PATTERN = `INST_START_ADDR;
	REG32_PP ir_inst(.Q(buf_ir), .D(DATA_IN), .LOAD(CTRL[4]), .CLK(CLK), .RESET(RST));
			
	MUX5_2x1 mux_r1_inst(.Y(mux_r1_sel_1),
			.I0(buf_ir[25:21]), .I1(5'b0), .S(CTRL[5]));
	
	MUX5_2x1 mux_wa_inst_1(.Y(mux_wa_sel_1),
			.I0(buf_ir[20:16]), .I1(buf_ir[15:11]), .S(CTRL[8]));
	MUX5_2x1 mux_wa_inst_2(.Y(mux_wa_sel_2),
			.I0(5'b0), .I1(5'b11111), .S(CTRL[9]));
	MUX5_2x1 mux_wa_inst_3(.Y(mux_wa_sel_3),
			.I0(mux_wa_sel_2), .I1(mux_wa_sel_1), .S(CTRL[10]));
	
	MUX32_2x1 mux_wd_inst_1(.Y(mux_wd_sel_1),
			.I0(alu_result), .I1(DATA_IN), .S(CTRL[11]));
	MUX32_2x1 mux_wd_inst_2(.Y(mux_wd_sel_2),
			.I0(mux_wd_sel_1), .I1({buf_ir[15:0], {16{buf_ir[15:0]}}}), .S(CTRL[12]));
	MUX32_2x1 mux_wd_inst_3(.Y(mux_wd_sel_3),
			.I0(rc_1_pc_load), .I1(mux_wd_sel_2), .S(CTRL[13]));
	
	REGISTER_FILE_32x32 reg_file_inst(.DATA_R1(buf_r1_data), .DATA_R2(buf_r2_data),
			.ADDR_R1(mux_r1_sel_1), .ADDR_R2(buf_ir[20:16]), .DATA_W(mux_wa_sel_3),
			.ADDR_W(mux_wd_sel_3), .READ(CTRL[6]), .WRITE(CTRL[7]),
			.CLK(CLK), .RST(RST));
	
	BUF32_1x1 buf32_inst_1(.Y(INSTRUCTION), .A(buf_ir));
			
	defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
	REG32_PP sp_inst(.Q(buf_sp), .D(alu_result), .LOAD(sp_load), .CLK(CLK), .RESET(RST));
	
	MUX32_2x1 mux_op1_inst(.Y(mux_op1_sel_1),
			.I0(buf_r1_data), .I1(buf_sp), .S(CTRL[15]));
	MUX32_2x1 mux_op2_inst_1(.Y(mux_op2_sel_1),
			.I0(1), .I1({{27'b0}, buf_ir[10:6]}), .S(CTRL[16]));
	MUX32_2x1 mux_op2_inst_2(.Y(mux_op2_sel_2),
			.I0({{16'b0}, buf_ir[15:0]}), .I1({{16{buf_ir[15]}}, buf_ir[15:0]}), .S(CTRL[17]));
	MUX32_2x1 mux_op2_inst_3(.Y(mux_op2_sel_3),
			.I0(mux_op2_sel_2), .I1(mux_op2_sel_1), .S(CTRL[18]));
	MUX32_2x1 mux_op2_inst_4(.Y(mux_op2_sel_4),
			.I0(mux_op2_sel_3), .I1(buf_r2_data), .S(CTRL[19]));
	
	ALU alu_inst(.OUT(alu_result), .ZERO(ZERO),
			.OP1(mux_op2_sel_4), .OP2(mux_op1_sel_1), .OPRN(CTRL[20:15]));
	
	MUX32_2x1 mux_ma_inst_1(.Y(mux_ma_sel_1),
			.I0(alu_result), .I1(buf_sp), .S(CTRL[26]));
	MUX32_2x1 mux_ma_inst_2(.Y(mux_ma_sel_2),
			.I0(mux_ma_sel_1), .I1(buf_sp), .S(CTRL[27]));
	BUF32_1x1 buf32_inst_2(.Y(ADDR), .A(mux_ma_sel_2));
	
	MUX32_2x1 mux_md_inst(.Y(mux_md_sel_1),
			.I0(buf_r2_data), .I1(buf_r1_data), .S(CTRL[28]));
	BUF32_1x1 buf32_inst_3(DATA_OUT, mux_md_sel_1);
	
endmodule
