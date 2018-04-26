module IW_testbench();
	//inputs are registers and outputs are wires
	reg [31:0]i;
	reg p_state;
	wire [93:0]CW;
	
	/*
	Testbench design:
	Two instructions will be tested:
	1. MOVZ
	2. MOVK
	Then the outputs of each will be observed
	*/
	
	// internal wires
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	//initialization
	IW dut(i, p_state, CW);
	
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
		p_state <= 1'b0;
	end
	
	always begin
		#10
		i <= 32'b110100101_01_1111111111111111_00000; // MOVZ instruction
		//p_state <= 1'b0;
		
		#10
		i <= 32'b111100101_10_1111111111111111_00001; // MOVK instruction
		p_state <= 1'b0;
		
		#10
		//i <= 32'b111100101_10_1111111111111111_00001; // MOVK instruction
		p_state <= 1'b1;
		
		#10
		i = 32'b11010010100000000000000001000010; // MOVZ X2, 2
		p_state <= 1'b0;


		#50 $stop;
	end
	

endmodule
