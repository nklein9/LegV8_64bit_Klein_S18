module rom_case(out, address);
	output reg [31:0]out;
	input [15:0] address; // address - 16 deep memory

/*
			C code:
			
			int n = 100
			int a = & array1[0]; // mem address 400
			int b = & array2[0]; // mem address 1200
			while (n--)
				*b++ = *a++;
			
			Assembly language:
			
			ADDI X4, XZR, 100 // n = 100
			MOVZ X8, 400 
			MOVZ X9, 1200
			CBZ X4, end 6
			SUBI X4, X4, 1
			LDUR X10, [X8, 0]
			ADDI X8, X8, 8
			STUR X20, [X9, 0]
			ADDI X9, X9, 8
			B -7 // always branch back 7 lines, no condition
			
			where n -> X4, a -> X8, b -> X9, X10 is temp value
*/
	always @(address) begin
		case(address)
			16'h0000: out = 32'b1001000100_000001100100_11111_00100; // ADDI X4, XZR, 100
			16'h0001: out = 32'b110100101_00_0000000110010000_01000; // MOVZ X8, 400
			16'h0002: out = 32'b110100101_00_0000010010110000_01001; // MOVZ X9, 1200
			16'h0003: out = 32'b10110100_0000000000000000110_00100;  // CBZ X4, 6
			16'h0004: out = 32'b1101000100_000000000001_00100_00100; // SUBIX4, X4, 1
			16'h0005: out = 32'b11111000010_000000000_00_01000_01010;// LDUR X10, [X8, 0]
			16'h0006: out = 32'b1001000100_000000001000_01000_01000; // ADDI X8, X8, 8
			16'h0007: out = 32'b11111000000_000000000_00_01001_01010;// STUR X10, [X9, 0]
			16'h0008: out = 32'b1001000100_000000001000_01001_01001; // ADDI X9, X9, 8
			16'h0009: out = 32'b000101_11111111111111111111111001;   // B -7
			default : out = 32'hD60003E0; 									// BR XZR
			
			endcase
		end



endmodule	
