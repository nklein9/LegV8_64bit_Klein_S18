module CBZ_CBNZ_testbench();
	//inputs are registers and outputs are wires
	reg [31:0]i;
	reg z;
	wire [93:0]CW;
	
	/*
	Testbench design:
	Two  instruction will be tested:
	1. CBZ
	2. CBNZ
	Then the outputs of each will be observed
	*/
	
	// internal wires
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	//initialization
	CBZ_CBNZ dut(i, z, CW);
	
	assign DA = dut.DA;
	assign SA = dut.SA;
	assign SB = dut.SB;
	assign FS = dut.FS;
	assign PS = dut.PS;
	assign enable = dut.enable;
	assign regWrite = dut.regWrite;
	assign memWrite = dut.memWrite;
	assign PC_sel = dut.PC_sel;
	assign B_sel = dut.B_sel;
	assign status_load = dut.status_load;
	assign k = dut.k;
	assign state = dut.state;
	
	//Start of testing
	initial begin
		i <= 32'b0;
		z <= 1'b0;
	end
	
	always begin
		
		#10
		// z <= 1'b0;
		i <= 32'b10110100_1010101010101010101_00000; // CBZ instruction
		
		#10
		// z <= 1'b0;
		i <= 32'b10110101_0101010101010101010_00001; // CBNZ instruction

		#10
		z <= 1'b1;
		i <= 32'b10110100_1010101010101010101_00000; // CBZ instruction
		
		#10
		// z <= 1'b1;
		i <= 32'b10110101_0101010101010101010_00001; // CBNZ instruction

		#50 $stop;
	end
	
endmodule
