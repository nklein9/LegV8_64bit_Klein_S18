module RI_Logic_testbench();
	//inputs are registers and outputs are wires
	reg [31:0]i;
	wire [93:0]CW;
	
	/*
	Testbench design:
	Eight instructions will be tested:
	1. ANDI
	2. ORRI
	3. EORI
	4. ANDIS
	5. AND
	6. OR
	7. EOR
	8. ANDS
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
		#10
		i <= 32'b1001001000_000000000001_00000_00001; // ANDI instruction
		
		#10
		i <= 32'b1011001000_000000000010_00010_00011; // ORRI instruction
		
		#10
		i <= 32'b1101001000_000000000100_00100_00101; // EORI instruction
		
		#10
		i <= 32'b1111001000_000000001000_00110_00111; // ANDIS instruction
		
		#10
		i <= 32'b10001010000_11111_000000_10000_00100; // AND instruction

		#10
		i <= 32'b10101010000_01111_000000_10000_00100; // ORR instruction
		
		#10
		i <= 32'b11001010000_00111_000000_10000_00100; // EOR instruction
		
		#10
		i <= 32'b11101010000_00011_000000_10000_00100; // ANDS instruction

		
		#50 $stop;
	end
	
endmodule
