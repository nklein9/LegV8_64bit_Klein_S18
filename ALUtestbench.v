module ALU_Testbecnch();
	wire [63:0] F;
	reg [63:0] A, B;
	wire [3:0] status;
	reg [4:0] FS;
	
	ALU sut (F, status, A, B, FS);
	

endmodule
