module MPC(clk, rst, en, Din, OUT);
input clk, rst, en;
input signed [17:0] Din;
output signed [27:0] OUT;

reg signed [27:0] D [0:13];
wire signed [27:0] D_4;
wire signed [27:0] D_9;
wire signed [27:0] D_13;

integer i;

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    for(i = 0; i < 14; i = i + 1) begin
	    	D[i] <= 28'd0;
	    end
	end
	else if(en) begin
		for(i = 1; i < 14; i = i + 1) begin
			D[0] <= {Din, 10'd0};
			D[i] <= D[i - 1];
		end
	end
	else begin
		for(i = 0; i < 14; i = i + 1) begin
			D[i] <= D[i];
		end
	end
end

assign D_4 = (D[4] >>> 2) + (D[4] >>> 4) + (D[4] >>> 9) + (D[4] >>> 10);
assign D_9 = (D[9] >>> 1);
assign D_13 = (D[13] >>> 7) + (D[13] >>> 9);

assign OUT = D[0] + D_9 + D_13;

endmodule