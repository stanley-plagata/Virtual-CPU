`timescale 1ns/1ps

module TWOSCOMP32_TB;
	reg [31:0] A;
	wire [31:0] Y;
	
	TWOSCOMP32 twoscomp32_inst_1(.Y(Y), .A(A));
	
	initial begin
		A = 'b00000000000000000000000000000111;
		#5 A = 'b00000000000000000000000000000001; $write("Y =: %b\n", Y);
		#5 A = 'b00000000000000000000000000000100; $write("Y =: %b\n", Y);
		#5 $write("Y =: %b\n", Y);
		$stop;
	end
endmodule
