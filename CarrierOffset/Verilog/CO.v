// `include "D:/William/Course/Base_Band/Lab05/Verilog/NCO/.NCO.v"

module CO(clk, rst, en, I, Q, I_ro, Q_ro);
input clk, rst, en;
input [1:0] I;
input [1:0] Q;
output reg signed [13:0] I_ro;
output reg signed [13:0] Q_ro; 

wire signed [11:0] ncos;
wire signed [11:0] nsin;
wire signed [13:0] I_temp0;
wire signed [13:0] Q_temp0;
reg signed [13:0] I_temp;
reg signed [13:0] Q_temp;
wire signed [13:0] cos_temp;
wire signed [13:0] sin_temp;
wire signed [13:0] sin_minus;

NCO u_NCO(.clk(clk),
	      .rst(rst),
	      .en(1),
	      .ncos(ncos),
	      .nsin(nsin)
	      );

assign I_temp0 ={I[1], I[1], I[1], I[1], I[1], I[1], I[1], I[1], I[1], I[1], I[1], I[1], I};
assign Q_temp0 ={Q[1], Q[1], Q[1], Q[1], Q[1], Q[1], Q[1], Q[1], Q[1], Q[1], Q[1], Q[1], Q};

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    I_temp <= 0;
	    Q_temp <= 0;
	end
	else begin
		I_temp <= I_temp0;
		Q_temp <= Q_temp0;
	end
end

assign cos_temp = {ncos[11], ncos[11] ,ncos};
assign sin_temp = {nsin[11], nsin[11] ,nsin};
assign sin_minus = (~sin_temp) + 1;

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    I_ro <= 13'd0;
	    Q_ro <= 13'd0;
	end
	else if (en) begin
		I_ro <= I_temp*cos_temp + Q_temp*sin_minus;
		Q_ro <= I_temp*sin_temp + Q_temp*cos_temp;
	end
	else begin
		I_ro <= I_ro;
		Q_ro <= Q_ro;
	end
end

endmodule