module adder1bit (a, b, cin, cout, sum);
	input a, b, cin;
	output cout, sum;

	assign cout = a&b + b&cin + a+cin;
	assign sum = (a xor b xor cin) + (a&b&cin);
	
endmodule
