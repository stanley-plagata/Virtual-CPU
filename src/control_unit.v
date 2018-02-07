// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: CTRL  : Control signal for data path
//         READ  : Memory read signal
//         WRITE : Memory Write signal
//
// Input:  ZERO : Zero status from ALU
//         CLK  : Clock signal
//         RST  : Reset Signal
//
// Notes: - Control unit synchronize operations of a processor
//          Assign each bit of control signal to control one part of data path
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
	// Output signals
	output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
	output READ, WRITE;

	// input signals
	input ZERO, CLK, RST;
	input [`DATA_INDEX_LIMIT:0] INSTRUCTION;
 
	// TBD - take action on each +ve edge of clock
	reg [`CTRL_WIDTH_INDEX_LIMIT:0] CTRL;
	reg READ, WRITE;
	
	reg [5:0] opcode;
	reg [4:0] rs;
	reg [4:0] rt;
	reg [4:0] rd;
	reg [4:0] shamt;
	reg [5:0] funct;
	reg [15:0] immediate;
	reg [25:0] address;
	
	/*
	CTRL[0] = pc_load
	CTRL[1] = pc_sel_1
	CTRL[2] = pc_sel_2
	CTRL[3] = pc_sel_3
	CTRL[4] = ir_load
	CTRL[5] = rl_sel_1
	CTRL[6] = reg_r
	CTRL[7] = reg_w
	CTRL[8] = wa_sel_1
	CTRL[9] = wa_sel_2
	CTRL[10] = wa_sel_3
	CTRL[11] = wd_sel_1
	CTRL[12] = wd_sel_2
	CTRL[13] = wd_sel_3
	CTRL[14] = sp_load
	CTRL[15] = op1_sel_1
	CTRL[16] = op2_sel_1
	CTRL[17] = op2_sel_2
	CTRL[18] = op2_sel_3
	CTRL[19] = op2_sel_4
	CTRL[20] = alu_oprn[0]
	CTRL[21] = alu_oprn[1]
	CTRL[22] = alu_oprn[2]
	CTRL[23] = alu_oprn[3]
	CTRL[24] = alu_oprn[4]
	CTRL[25] = alu_oprn[5]
	CTRL[26] = ma_sel_1
	CTRL[27] = ma_sel_2
	CTRL[28] = md_sel_1
	*/

	// State nets
	wire [2:0] proc_state;

	PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

	always @ (proc_state) begin
	// TBD: Code for the control unit model
		case (proc_state)
			`PROC_FETCH: begin
				READ = 1;
				WRITE = 0;
				CTRL = 32'bX;
				CTRL[0] = 0;	// pc_load = 0
				CTRL[7] = 0;	// reg_w = 0;
				CTRL[14] = 0;	// sp_load = 0;
			end
			
			`PROC_DECODE: begin
				// parse the instruction
				CTRL[5] = 0;	// r1_sel_1 = 0
				CTRL[6] = 1;	// reg_r = 1
				CTRL[7] = 0;	// reg_w = 0
				{opcode, rs, rt, rd, shamt, funct} = INSTRUCTION;	// R-type
				{opcode, rs, rt, immediate} = INSTRUCTION;			// I-type
				{opcode, address} = INSTRUCTION;					// J-type
				print_instruction(INSTRUCTION);
			end

			`PROC_EXE: begin
				case(opcode)
					/* R-Type */
					6'h00: begin
						case(funct)
							// addition
							6'h20: begin
								CTRL[16] = 0;	// op2_sel_1 = 0
								CTRL[19] = 1;	// op2_sel_4 = 1
								CTRL[25:20] = 000001;
							end
							// subtraction
							6'h22: begin
								CTRL[16] = 0;	// op2_sel_1 = 0
								CTRL[19] = 1;	// op2_sel_4 = 1
								CTRL[25:20] = 000010;
							end
							// multiplication
							6'h2c: begin
								CTRL[16] = 0;	// op2_sel_1 = 0
								CTRL[19] = 1;	// op2_sel_4 = 1
								CTRL[25:20] = 000011;
							end
							// logical AND
							6'h24: begin
								CTRL[16] = 0;	// op2_sel_1 = 0
								CTRL[19] = 1;	// op2_sel_4 = 1
								CTRL[25:20] = 000110;
							end
							// logical OR
							6'h25: begin
								CTRL[16] = 0;	// op2_sel_1 = 0
								CTRL[19] = 1;	// op2_sel_4 = 1
								CTRL[25:20] = 000111;
							end
							// logical NOR
							6'h27: begin
								CTRL[16] = 0;	// op2_sel_1 = 0
								CTRL[19] = 1;	// op2_sel_4 = 1
								CTRL[25:20] = 001000;
							end
							// set_less_than
							6'h2a: begin
								CTRL[16] = 0;	// op2_sel_1 = 0
								CTRL[19] = 1;	// op2_sel_4 = 1
								CTRL[25:20] = 001001;
							end
							// shift_left_logical
							6'h01: begin
								CTRL[15] = 0;	// op1_sel_1 = 0
								CTRL[16] = 1;	// op2_sel_1 = 1
								CTRL[18] = 1;	// op2_sel_3 = 1
								CTRL[19] = 0;	// op2_sel_4 = 0
								CTRL[25:20] = 000100;
							end
							// shift_right_logical
							6'h02: begin
								CTRL[15] = 0;	// op1_sel_1 = 0
								CTRL[16] = 1;	// op2_sel_1 = 1
								CTRL[18] = 1;	// op2_sel_3 = 1
								CTRL[19] = 0;	// op2_sel_4 = 0
								CTRL[25:20] = 000101;
							end
							// jump_register
							6'h08: begin
								// n/a;
							end
						endcase
					end

					/* I-type */
					// addition_immediate
					6'h08: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[17] = 0;	// op2_sel_2 = 0
						CTRL[18] = 0;	// op2_sel_3 = 0
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 000001;
					end
					// multiplication_immediate
					6'h1d: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[17] = 0;	// op2_sel_2 = 0
						CTRL[18] = 0;	// op2_sel_3 = 0
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 000011;
					end
					// logical_AND_immediate
					6'h0c: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[17] = 0;	// op2_sel_2 = 0
						CTRL[18] = 0;	// op2_sel_3 = 0
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 000110;
					end
					// logical_OR_immediate
					6'h0d: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[17] = 0;	// op2_sel_2 = 0
						CTRL[18] = 0;	// op2_sel_3 = 0
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 000111;
					end
					// load_upper_immediate
					6'h0f: begin
						// n/a;
					end
					//set_less_than_immediate
					6'h0a: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[17] = 0;	// op2_sel_2 = 0
						CTRL[18] = 0;	// op2_sel_3 = 0
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 001001;
					end
					// branch_on_equal
					6'h04: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[19] = 1;	// op2_sel_4 = 1
						CTRL[25:20] = 000010;
					end
					// branch_on_not_equal
					6'h05: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[19] = 1;	// op2_sel_4 = 1
						CTRL[25:20] = 000010;
					end
					// load_word
					6'h23: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[17] = 1;	// op2_sel_2 = 1
						CTRL[18] = 0;	// op2_sel_3 = 0
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 000001;
					end
					// store_word
					6'h2b: begin
						CTRL[15] = 0;	// op1_sel_1 = 0
						CTRL[17] = 1;	// op2_sel_2 = 1
						CTRL[18] = 0;	// op2_sel_3 = 0
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 000001;
					end

					/* J-Type */
					// jump_to_address
					6'h02: begin
						// n/a;
					end
					// jump_and_link
					6'h03: begin
						// n/a;
					end
					// push_to_stack
					6'h1b: begin
						// n/a;
					end
					// pop_from_stack
					6'h1c: begin
						CTRL[15] = 1;	// op1_sel_1 = 1
						CTRL[16] = 0;	// op2_sel_1 = 0
						CTRL[18] = 1;	// op2_sel_3 = 1
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[25:20] = 000001;
					end
				endcase
			end

			`PROC_MEM: begin
				case (opcode)
					6'h23: begin // load_word
						CTRL[26] = 0;	// ma_sel_1 = 0
					end
					6'h2b: begin // store_word
						CTRL[26] = 0;	// ma_sel_1 = 0
						CTRL[28] = 0;	// md_sel_1 = 0
					end
					6'h1b: begin // push_to_stack
						CTRL[26] = 1;	// ma_sel_1 = 1
						CTRL[28] = 1;	// md_sel_1 = 1
					end
					6'h1c: begin // pop_from_stack
						CTRL[26] = 1;	// ma_sel_1 = 1
					end
				endcase
			end

			`PROC_WB: begin
				case (opcode)
					/* R-Type */
					6'h00: begin
						if (funct != 6'h08) begin
							CTRL[1] = 1;	// pc_sel_1 = 1
							CTRL[2] = 0;	// pc_sel_2 = 0
							CTRL[3] = 1;	// pc_sel_3 = 1
							CTRL[8] = 0;	// wa_sel_1 = 0
							CTRL[10] = 1;	// wa_sel_3 = 1
							CTRL[11] = 0;	// wd_sel_1 = 0
							CTRL[12] = 0;	// wd_sel_2 = 0
							CTRL[13] = 1;	// wd_sel_3 = 1
						end
						else begin
							CTRL[1] = 0;	// pc_sel_1 = 0
							CTRL[2] = 0;	// pc_sel_2 = 0
							CTRL[3] = 1;	// pc_sel_3 = 1
						end
					end

					/* I-Type */
					6'h08: begin // addition_immediate
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[8] = 0;	// wa_sel_1 = 1
						CTRL[10] = 1;	// wa_sel_3 = 1
						CTRL[11] = 0;	// wd_sel_1 = 0
						CTRL[12] = 0;	// wd_sel_2 = 0
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
					6'h1d: begin // multiplication_immediate
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[8] = 0;	// wa_sel_1 = 1
						CTRL[10] = 1;	// wa_sel_3 = 1
						CTRL[11] = 0;	// wd_sel_1 = 0
						CTRL[12] = 0;	// wd_sel_2 = 0
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
					6'h0c: begin // logical_AND_immediate
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[8] = 0;	// wa_sel_1 = 1
						CTRL[10] = 1;	// wa_sel_3 = 1
						CTRL[11] = 0;	// wd_sel_1 = 0
						CTRL[12] = 0;	// wd_sel_2 = 0
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
					6'h0d: begin // logical_OR_immediate
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[8] = 0;	// wa_sel_1 = 1
						CTRL[10] = 1;	// wa_sel_3 = 1
						CTRL[11] = 0;	// wd_sel_1 = 0
						CTRL[12] = 0;	// wd_sel_2 = 0
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
					6'h0f: begin // load_upper_immediate
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[8] = 0;	// wa_sel_1 = 1
						CTRL[10] = 1;	// wa_sel_3 = 1
						CTRL[12] = 0;	// wd_sel_2 = 1
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
					6'h0a: begin // set_less_than_immediate
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[8] = 0;	// wa_sel_1 = 1
						CTRL[10] = 1;	// wa_sel_3 = 1
						CTRL[11] = 0;	// wd_sel_1 = 0
						CTRL[12] = 0;	// wd_sel_2 = 0
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
					6'h04: begin // branch_on_equal
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
					end
					6'h05: begin // branch_not_on_equal
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
					end
					6'h23: begin // load_word
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[8] = 0;	// wa_sel_1 = 1
						CTRL[10] = 1;	// wa_sel_3 = 1
						CTRL[11] = 0;	// wd_sel_1 = 1
						CTRL[12] = 0;	// wd_sel_2 = 0
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
					6'h2b: begin // store_word
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
					end

					/* J-Type */
					6'h02: begin // jump_to_address
						CTRL[1] = 0;	// pc_sel_1 = 0
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
					end
					6'h03: begin // jump_and_link
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[6] = 0;	// reg_r = 0
						CTRL[7] = 1;	// reg_w = 1
						CTRL[9] = 1;	// wa_sel_2 = 1
						CTRL[10] = 0;	// wa_sel_3 = 0
						CTRL[13] = 0;	// wd_sel_3 = 0
					end
					6'h1b: begin // push_to_stack
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[15] = 1;	// op1_sel_1 = 1
						CTRL[16] = 0;	// op2_sel_1 = 0
						CTRL[18] = 1;	// op2_sel_3 = 1
						CTRL[19] = 0;	// op2_sel_4 = 0
						CTRL[20:15] = 000010;
					end
					6'h1c: begin // pop_from_stack
						CTRL[1] = 1;	// pc_sel_1 = 1
						CTRL[2] = 0;	// pc_sel_2 = 0
						CTRL[3] = 1;	// pc_sel_3 = 1
						CTRL[9] = 0;	// wa_sel_2 = 0
						CTRL[10] = 0;	// wa_sel_3 = 0
						CTRL[11] = 1;	// wd_sel_1 = 1
						CTRL[12] = 0;	// wd_sel_2 = 0
						CTRL[13] = 1;	// wd_sel_3 = 1
					end
				endcase
			end
		endcase
	end

	task print_instruction;
		input [`DATA_INDEX_LIMIT:0] inst;

		reg [5:0] opcode;
		reg [4:0] rs;
		reg [4:0] rt;
		reg [4:0] rd;
		reg [4:0] shamt;
		reg [5:0] funct;
		reg [15:0] immediate;
		reg [25:0] address;

		begin
			// parse the instruction
			// R-type
			{opcode, rs, rt, rd, shamt, funct} = inst;
			// I-type
			{opcode, rs, rt, immediate } = inst;
			// J-type
			{opcode, address} = inst;
			$write("@ %6dns -> [0X%08h] ", $time, inst);
			case(opcode)
				/* R-Type */
				6'h00:
				begin
					case(funct)
						6'h20: $write("add r[%02d], r[%02d], r[%02d];", rs, rt, rd);
						6'h22: $write("sub r[%02d], r[%02d], r[%02d];", rs, rt, rd);
						6'h2c: $write("mul r[%02d], r[%02d], r[%02d];", rs, rt, rd);
						6'h24: $write("and r[%02d], r[%02d], r[%02d];", rs, rt, rd);
						6'h25: $write("or r[%02d], r[%02d], r[%02d];", rs, rt, rd);
						6'h27: $write("nor r[%02d], r[%02d], r[%02d];", rs, rt, rd);
						6'h2a: $write("slt r[%02d], r[%02d], r[%02d];", rs, rt, rd);
						6'h00: $write("sll r[%02d], %2d, r[%02d];", rs, shamt, rd);
						6'h02: $write("srl r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
						6'h08: $write("jr r[%02d];", rs);
						default: $write("");
					endcase
				end
				/* I-type */
				6'h08 : $write("addi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h1d : $write("muli r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h0c : $write("andi r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h0d : $write("ori r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h0f : $write("lui r[%02d], 0X%04h;", rt, immediate);
				6'h0a : $write("slti r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h04 : $write("beq r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h05 : $write("bne r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h23 : $write("lw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				6'h2b : $write("sw r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
				/* J-Type */
				6'h02 : $write("jmp 0X%07h;", address);
				6'h03 : $write("jal 0X%07h;", address);
				6'h1b : $write("push;");
				6'h1c : $write("pop;");
				default: $write("");
			endcase
		$write("\n");
		end
	endtask
endmodule


//------------------------------------------------------------------------------------------
// Module: PROC_SM
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE, CLK, RST);
	// list of inputs
	input CLK, RST;
	// list of outputs
	output [2:0] STATE;

	// TBD - take action on each +ve edge of clock
	reg [2:0] STATE;
	reg [2:0] NEXT_STATE;

	initial begin
		STATE = 2'bxx;
		NEXT_STATE = `PROC_FETCH;
	end

	always @ (negedge RST) begin
		STATE = 2'bxx;
		NEXT_STATE = `PROC_FETCH;
	end

	always @ (posedge CLK) begin
		case (NEXT_STATE)
			`PROC_FETCH: begin
				STATE = NEXT_STATE;
				NEXT_STATE = `PROC_DECODE;
			end
			`PROC_DECODE: begin
				STATE = NEXT_STATE;
				NEXT_STATE = `PROC_EXE;
			end
			`PROC_EXE: begin
				STATE = NEXT_STATE;
				NEXT_STATE = `PROC_MEM;
			end
			`PROC_MEM: begin
				STATE = NEXT_STATE;
				NEXT_STATE = `PROC_WB;
			end
			`PROC_WB: begin
				STATE = NEXT_STATE;
				NEXT_STATE = `PROC_FETCH;
			end
			default: begin
				STATE = 2'bxx;
				NEXT_STATE = `PROC_FETCH;
			end
		endcase
	end
endmodule