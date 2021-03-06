`timescale 1ns/1ps

module MULT32_TB;
	reg [31:0] A, B;
	wire [31:0] HI, LO;
	
	MULT32 mult_inst_1(.HI(HI), .LO(LO), .A(A), .B(B));
	
	initial begin
		A = 'b00000000000000000000000000000100; B = 'b00000000000000000000000000001010; // A = 4, B = 10
		#5 A = 'b00000000000000000000000000000000; B = 'b00000000000000000000000000000011; $write("HI =: %d, LO =: %d\n", HI, LO); // A = 0, B = 3
		#5 A = 'b00000000000000000000000000001000; B = 'b00000000000000000000000000001000; $write("HI =: %d, LO =: %d\n", HI, LO); // A = 8, B = 8
		#5 A = 'b00000000000000000000000000000010; B = 'b00000000000000000000000000000000; $write("HI =: %d, LO =: %d\n", HI, LO); // A = 2, B = 0
		#5 A = 'b00000000000000000000000000001111; B = 'b00000000000000000000000000000111; $write("HI =: %d, LO =: %d\n", HI, LO); // A = 15, B = 7
		#5 $write("HI =: %d, LO =: %d\n", HI, LO);
		$stop;
	end
endmodule
