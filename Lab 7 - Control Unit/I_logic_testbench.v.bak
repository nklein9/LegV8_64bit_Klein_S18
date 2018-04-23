module I_logic_testbench();
	//inputs are registers and outputs are wires
	reg [31:0]i;
	wire [93:0]CW;
	
	/*
	Testbench design:
	Four instructions will be tested:
	1. ANDI
	2. ORRI
	3. EOR
	4. ANDIS
	Then the outputs of each will be observed
	*/
	
	// internal wires
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	//initialization
	I_logic dut(i, CW);
	
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
		#8
		i <= 32'b1001001000_000000000001_00000_00001; // ADDI instruction
		
		#10
		i <= 32'b1011001000_000000000010_00010_00011; // SUBI instruction
		
		#10
		i <= 32'b1101001000_000000000100_00100_00101; // ADDIS instruction
		
		#10
		i <= 32'b1111001000_000000001000_00110_00111; // SUBIS instruction
		
		#50 $stop;
	end
	
endmodule
