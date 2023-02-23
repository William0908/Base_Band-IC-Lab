`timescale 1ns/10ps
`define CYCLE 20
`define End_CYCLE 100000

module nco_tb;
reg clk = 0;
reg rst = 0;
reg en = 0;
wire [11:0] ncos, nsin;

integer i;

NCO u_NCO(.clk(clk),
	      .rst(rst),
	      .en(en),
	      .ncos(ncos),
	      .nsin(nsin)
	      );

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	rst = 1'b1;
	#(`CYCLE*3); @(negedge clk) rst = 1'd0;
	@(posedge clk) en = 1'b1;
end

initial  begin
 #`End_CYCLE ;
 	$finish;
end

endmodule