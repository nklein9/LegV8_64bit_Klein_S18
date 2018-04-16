//Nicholas Klein
//Last Edit March 26, 2018
module RomCase (out, address);
	output reg [31:0] out;
	input [15:0] address;
	
	always @ (address) begin
		case (address)
			//from class
				//n = 100;
				//a = &array1[0];
				//b = &array2 [0];
				//while (n--) (
				//		*B++ = *A++;
				//)
				//where n -> X4, A -> X8, b -> X9, X10 is a temp value
			16'h0: out = 32'b1001000100_000001100100_11111_00100; //ADDI X4, XZR, 100;
			16'h1: out = 32'b110100101_00_0000000110010000_01000; //MOVZ X8, 400;
			16'h2: out = 32'b110100101_00_0000010010110000_01001; //MOVZ X9, 1200;
			16'h3: out = 32'b10110100_0000000000000000110_00100; //CBZ X4, 6;
			16'h4: out = 32'b1101000100_000000000001_00100_00100; //SUBI X4, X4, 1;
			16'h5: out = 32'b11111000010_000000000_00_01000_01010;//LDUR X10, [X8,0]
			16'h6: out = 32'b1001000100_000000001000_01000_01000;//ADDI X8, X8, 8
			16'h7: out = 32'b11111000000_000000000_00_01001_01010 ;//STUR x10, [X9, 0]
			16'h8: out = 32'b1001000100_0000000000_00_01001_01011;//ADDI X9, X9, 8
			16'h9: out = 32'b000101_11111111111111111111111001; //B -7
			default: out = 32'hD60003E0; //BR XZR
		endcase
	end
endmodule