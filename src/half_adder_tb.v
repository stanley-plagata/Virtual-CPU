`timescale 1ns/1ps

module HALF_ADDER_TB;
	reg A, B;
	wire Y, C;
	
	HALF_ADDER hs_inst_1(.Y(Y), .C(C), .A(A), .B(B));
	
	initial begin
		A = 0; B = 0;
		#5 A = 1; B = 0; $write("Y =: %d, C =: %d\n", Y, C);
		#5 A = 0; B = 1; $write("Y =: %d, C =: %d\n", Y, C);
		#5 A = 1; B = 1; $write("Y =: %d, C =: %d\n", Y, C);
		#5 $write("Y =: %d, C =: %d\n", Y, C);
		$stop;
	end
endmodule
