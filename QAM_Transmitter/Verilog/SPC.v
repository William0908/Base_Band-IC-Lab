module SPC(clk, rst, en, Din, OUT);
input clk, rst, en;
input Din;
output reg [1:0] OUT;
//
reg swap;

// Swap signal
always @(posedge clk or posedge rst) begin
	if (rst) begin
	    swap <= 1'd0;
	end
	else if(en) begin
		swap <= ~swap;
	end
	else begin
		swap <= swap;
	end
end

// Output parallel signal
always @(posedge clk or posedge rst) begin
	if (rst) begin
	    OUT <= 2'd0;
	end
	else if(en) begin
		if(!swap) OUT[0] <= Din;
		else OUT <= (OUT << 1) | Din;
	end
	else begin
		OUT <= OUT;
	end
end

endmodule