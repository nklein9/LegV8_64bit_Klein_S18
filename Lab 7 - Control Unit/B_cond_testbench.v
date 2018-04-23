module B_cond_testbench();
	/*
	Created by David Russo
	Last edited 4/17/2018
	
	Testbench design:
	16 conditions will be tested:
	1. EQ = 5'b00000 // i[4:0]
	2. NE = 5'b00001
	3. HS = 5'b00010
	4. LO = 5'b00011
	5. MI = 5'b00100
	6. PL = 5'b00101
	7. VS = 5'b00110
	8. VC = 5'b00111
	9. HI = 5'b01000
	10.LS = 5'b01001
	11.GE = 5'b01010
	12.LT = 5'b01011
	13.GT = 5'b01100
	14.LE = 5'b01101
	15.AL = 5'b01110
	16.NV = 5'b01111
	
	This testbench design is similar to the ALU testbench design.
	- Random values are generated for i[3:0] and status[3:0]
	- i[4] is always 0
	- Values of PS1_exp and PS[1] are compared. 
	- An exception is thrown when the two values are not equal
	
	*/
	
	//inputs are registers and outputs are wires
	reg [31:0]i;
	reg [3:0]status;
	wire [93:0]CW;
	
	// internal wires
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire V, C, Z, N;
	wire [63:0]k;
	wire state;
	
	//initialization
	B_cond dut(i, status, CW);
	
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
	assign V = dut.status[3];
	assign C = dut.status[2];
	assign Z = dut.status[1];
	assign N = dut.status[0];
	
	//Start of testing
	initial begin
		i <= 32'b01010100_1000000000000000001_00000;
		status = 4'b0000;
	#5000 $stop;
	end
	
	reg PS1_exp;
	always begin
		#10 status <= $random;
		i[3:0] <= $random;
		i[4] = 0;
	end
	
	always @(*) begin
		case(i[3:0]) // status = VCZN
			4'b0000: PS1_exp = status[1];
			4'b0001: PS1_exp = ~status[1];
			4'b0010: PS1_exp = status[2];
			4'b0011: PS1_exp = ~status[2];
			4'b0100: PS1_exp = status[0];
			4'b0101: PS1_exp = ~status[0];
			4'b0110: PS1_exp = status[3];
			4'b0111: PS1_exp = ~status[3];
			4'b1000: PS1_exp = status[2] & ~status[1];
			4'b1001: PS1_exp = ~status[2] & status[1];
			4'b1010: PS1_exp = ~(status[0] ^ status[3]);
			4'b1011: PS1_exp = (status[0] ^ status[3]);
			4'b1100: PS1_exp = ~status[1] & ~(status[0] ^ status[3]);
			4'b1101: PS1_exp = status[1] | (status[0] ^ status[3]);
			4'b1110: PS1_exp = 1'b1;
			4'b1111: PS1_exp = 1'b1;
		endcase
	end
	always begin
		#40
		if(PS[1] != PS1_exp)
		begin
			$display("time: %d, i[3:0]: %d, status: %d, PS[1]: %d, PS1_exp: %d", $time, i[3:0], status, PS[1], PS1_exp);
		end
	end

endmodule
