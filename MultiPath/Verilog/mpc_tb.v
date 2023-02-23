`timescale 1ns/10ps
`define CYCLE 2.5
`define End_CYCLE 10000
`define PAT "D:/William/Course/Base_Band/Lab02/Matlab/IFout_bin.txt"

module mpc_tb;
reg clk = 0;
reg rst = 0;
reg en = 0;
reg signed [17:0] Din;
wire signed [27:0] OUT;

reg [17:0] data_mem [0:2047];

integer i, j;
integer file;

initial begin
	$readmemb(`PAT, data_mem);
end

MPC u_MPC(.clk(clk),
	      .rst(rst),
	      .en(en),
	      .Din(Din),
	      .OUT(OUT)
	      );

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	rst = 1'b1;
	#(`CYCLE*3); @(negedge clk) rst = 1'b0;
	Din = data_mem[0];
	@(posedge clk) en = 1'b1;
	for(i = 1; i < 2048; i = i + 1) begin
		@(negedge clk) Din = data_mem[i];
	end
end

initial begin
	file = $fopen("D:/William/Course/Base_Band/Lab04/Matlab/mpc_out.txt", "w");
	#(`CYCLE*3000);
	$fclose(file);
end

initial begin
	#(`CYCLE*3);
	for(j = 0; j < 2048; j = j + 1) begin
		#(`CYCLE*1);
        $display("%b\n", OUT);
        $fwrite(file, "%d\n", OUT);
	end
end

initial begin
	#(`End_CYCLE);
	$finish;
end

endmodule