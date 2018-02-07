`timescale 1ns/1ps

module DECODER_TB;
	//wire [3:0] D;
	//reg [1:0] I;
	wire [31:0] D;
	reg [4:0] I;
	
	//DECODER_2x4 dc_inst_1(.D(D), .I(I));
	DECODER_5x32 dc_inst_4(.D(D), .I(I));
	
	initial begin
		//I = 'b00;
		//#5 I = 'b01; $write("D =: %b\n", D);
		//#5 I = 'b10; $write("D =: %b\n", D);
		//#5 I = 'b11; $write("D =: %b\n", D);
		//#5 $write("D =: %b\n", D);
		//$stop;
		
		I = 'b00000;
		#5 I = 'b00001; $write("D =: %b\n", D);
		#5 I = 'b00010; $write("D =: %b\n", D);
		#5 I = 'b00011; $write("D =: %b\n", D);
		#5 I = 'b00100; $write("D =: %b\n", D);
		#5 I = 'b00101; $write("D =: %b\n", D);
		#5 I = 'b00110; $write("D =: %b\n", D);
		#5 I = 'b00111; $write("D =: %b\n", D);
		#5 I = 'b01000; $write("D =: %b\n", D);
		#5 I = 'b01001; $write("D =: %b\n", D);
		#5 I = 'b01010; $write("D =: %b\n", D);
		#5 I = 'b01011; $write("D =: %b\n", D);
		#5 I = 'b01100; $write("D =: %b\n", D);
		#5 I = 'b01101; $write("D =: %b\n", D);
		#5 I = 'b01110; $write("D =: %b\n", D);
		#5 I = 'b01111; $write("D =: %b\n", D);
		#5 I = 'b10000; $write("D =: %b\n", D);
		#5 I = 'b10001; $write("D =: %b\n", D);
		#5 I = 'b10010; $write("D =: %b\n", D);
		#5 I = 'b10011; $write("D =: %b\n", D);
		#5 I = 'b10100; $write("D =: %b\n", D);
		#5 I = 'b10101; $write("D =: %b\n", D);
		#5 I = 'b10110; $write("D =: %b\n", D);
		#5 I = 'b10111; $write("D =: %b\n", D);
		#5 I = 'b11000; $write("D =: %b\n", D);
		#5 I = 'b11001; $write("D =: %b\n", D);
		#5 I = 'b11010; $write("D =: %b\n", D);
		#5 I = 'b11011; $write("D =: %b\n", D);
		#5 I = 'b11100; $write("D =: %b\n", D);
		#5 I = 'b11101; $write("D =: %b\n", D);
		#5 I = 'b11110; $write("D =: %b\n", D);
		#5 I = 'b11111; $write("D =: %b\n", D);
		#5 $write("D =: %b\n", D);
		$stop;
	end
endmodule
