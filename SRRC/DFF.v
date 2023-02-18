`timescale 1ns/10ps
module DFF(clk, rst, D, Q);
input clk, rst;
input [17:0] D;
output reg [17:0] Q;

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    Q <= 18'd0;
	end
	else begin
		Q <= D;
	end
end

endmodule
