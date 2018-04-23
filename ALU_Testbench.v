module ALU_Testbench();
	wire [63:0]F;
	reg [63:0]A, B;
	wire [3:0]status;
	reg [4:0] FS;
	
	ALU_rev2 dut(A, B, FS, F, status); //Header of actual module: ALU_rev2(a, b, functionSelect, F, Status);
	
	initial begin
/*
		FS <= 5'b00000; // AND
		A <= 64'd2;
		B <= 64'd5; // 5 & 2 = 101 & 010 = 000
		#5 FS <= 5'b00100; // OR -> 5 | 2 = 101 | 010 = 111
		#5 FS <= 5'b01000; // ADD -> 5 + 2 = 7, 101 + 010 = 111
		A <= 64'd1;
		B <= 64'd15; // Set a = 0001 and b = 1111
		#5 FS <= 5'b01001; // SUB -> 
		#5 FS <= 5'b10000; // shift left
		#5 FS <= 5'b10100; // shift right
		A <= 64'h8000000000000000;
		#5 FS <= 5'b01100; // XOR
		A <= 64'd3;
		B <= 64'd6;
		
*/
		#5000 $stop;
	end
	

	reg [63:0]F_exp; // expected F value
	wire [63:0]A2, B2;
	assign A2 = FS[1] ? ~A : A;
	assign B2 = FS[0] ? ~B : B;

	always begin
		#5 FS <= $random;
		A <= {$random, $random};
		B <= {$random, $random};
	end
	
	always @(*) begin 
		case(FS[4:2])
			3'b000: F_exp = A2 & B2;
			3'b001: F_exp = A2 | B2;
			3'b010: F_exp = A2 + B2 + FS[0];
			3'b011: F_exp = A2 ^ B2;
			3'b100: F_exp = A2 << B2[5:0];
			3'b101: F_exp = A2 >> B2[5:0];
			3'b110: F_exp = 64'b0;
			3'b111: F_exp = 64'b0;
		endcase
	end
	always begin
		#5 FS <= $random;
		A <= {$random, $random};
		B <= {$random, $random};
	end
	always begin
		#40
		if(F != F_exp)
		begin
			$display("time: %d, FS: %x, A: %d, B: %d, F: %d, F_exp: %d", $time, FS, A, B, F, F_exp);
		end
	end
		
endmodule
