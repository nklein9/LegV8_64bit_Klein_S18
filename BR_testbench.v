module BR_testbench();
	//inputs are registers and outputs are wires
	reg [31:0]i;
	wire [93:0]CW;
	
	/*
	Testbench design:
	One instruction will be tested:
	1. BR
	Then the outputs of each will be observed
	*/
	
	// internal wires
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	//initialization
	BR dut(i, CW);
	
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
		i <= 32'b11010110000_11111_000000_00001_00000; // BR instruction
		
		#50 $stop;
	end
	
endmodule
