module D_testbench();
	//inputs are registers and outputs are wires
	reg [31:0]i;
	wire [93:0]CW;
	
	/*
	Testbench design:
	Two instructions will be tested:
	1. STUR
	2. LDUR
	Then the outputs of each will be observed
	*/
	
	// internal wires
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	//initialization
	D dut(i, CW);
	
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
	end
	
	always begin
		#10
		i <= 32'b11111000000_000000001_00_10000_00100; // STUR instruction
		
		#10
		i <= 32'b11111000010_000000010_00_10001_00100; // LDUR instruction
		
		#50 $stop;
	end
	

endmodule
