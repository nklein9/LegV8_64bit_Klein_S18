module RAM256x64(address, clock, in, write, Out);

	//inputs and output
	input [7:0]address;
	input clock;
	input [63:0]in;
	input write;
	
	output reg [63:0]Out;
	
	//logic
	reg [63:0]mem [0:255]; // 256 slot array of 64 bit vals
	
	always @(negedge clock)
	begin
		if(write)
		begin
			mem[address] <= in;
		end
	end
	
	always @(negedge clock)
	begin
		Out <= mem[address];
	end
	
endmodule
