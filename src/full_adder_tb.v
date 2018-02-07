`timescale 1ns/1ps

module FULL_ADDER_TB;
	reg A, B, CI;
	wire S, CO;
	
	FULL_ADDER fs_inst_1(.S(S), .CO(CO), .A(A), .B(B), .CI(CI));
	
	initial begin
		A = 0; B = 0; CI = 0;
		#5 A = 1; B = 0; CI = 0; $write("S =: %d, CO =: %d\n", S, CO);
		#5 A = 0; B = 1; CI = 0; $write("S =: %d, CO =: %d\n", S, CO);
		#5 A = 1; B = 1; CI = 0; $write("S =: %d, CO =: %d\n", S, CO);
		#5 A = 0; B = 0; CI = 1; $write("S =: %d, CO =: %d\n", S, CO);
		#5 A = 1; B = 0; CI = 1; $write("S =: %d, CO =: %d\n", S, CO);
		#5 A = 0; B = 1; CI = 1; $write("S =: %d, CO =: %d\n", S, CO);
		#5 A = 1; B = 1; CI = 1; $write("S =: %d, CO =: %d\n", S, CO);
		#5 $write("S =: %d, CO =: %d\n", S, CO);
		$stop;
	end
endmodule
