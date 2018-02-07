`timescale 1ns/1ps

module RC_ADD_SUB_TB;
	reg [31:0] A, B;
	reg SnA;
	wire [31:0] Y;
	wire CO;
	
	RC_ADD_SUB_32 rc_inst_1(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));
	
	initial begin
		A = 0; B = 0; SnA = 0;
		#5 A = 1; B = 0; SnA = 0; $write("Y =: %d, CO =: %d\n", Y, CO);
		#5 A = 0; B = 1; SnA = 0; $write("Y =: %d, CO =: %d\n", Y, CO);
		#5 A = 1; B = 1; SnA = 0; $write("Y =: %d, CO =: %d\n", Y, CO);
		#5 A = 0; B = 0; SnA = 1; $write("Y =: %d, CO =: %d\n", Y, CO);
		#5 A = 1; B = 0; SnA = 1; $write("Y =: %d, CO =: %d\n", Y, CO);
		#5 A = 0; B = 1; SnA = 1; $write("Y =: %d, CO =: %d\n", Y, CO);
		#5 A = 1; B = 1; SnA = 1; $write("Y =: %d, CO =: %d\n", Y, CO);
		#5 $write("Y =: %d, CO =: %d\n", Y, CO);
		$stop;
	end
endmodule
