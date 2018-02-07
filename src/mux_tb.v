`timescale 1ns/1ps

module MUX_TB;
	reg I0, I1, S;
	wire Y;
	
	MUX1_2x1 mux_inst_1(.Y(Y), .I0(I0), .I1(I1), .S(S));
	
	initial begin
		I0 = 0; I1 = 0; S = 0;
		#5 I0 = 0; I1 = 0; S = 1; $write("Y =: %d, \n", Y);
		#5 I0 = 1; I1 = 0; S = 0; $write("Y =: %d, \n", Y);
		#5 I0 = 1; I1 = 0; S = 1; $write("Y =: %d, \n", Y);
		#5 I0 = 0; I1 = 1; S = 0; $write("Y =: %d, \n", Y);
		#5 I0 = 0; I1 = 1; S = 1; $write("Y =: %d, \n", Y);
		#5 I0 = 1; I1 = 1; S = 0; $write("Y =: %d, \n", Y);
		#5 I0 = 1; I1 = 1; S = 1; $write("Y =: %d, \n", Y);
		#5 $write("Y =: %d, \n", Y);
		$stop;
	end
endmodule
