`timescale 1ns/10ps
`define CYCLE 20
`define End_CYCLE 100000

`define PAT1 "D:/William/Course/Base_Band/Lab05/Matlab/linear_u1_bin.txt"
`define PAT2 "D:/William/Course/Base_Band/Lab05/Matlab/linear_u2_bin.txt"
`define PAT3 "D:/William/Course/Base_Band/Lab05/Matlab/linear_u3_bin.txt"

module tpo_tb;
reg clk = 0;
reg rst = 0;
reg en = 0;
reg [7:0] Din;
wire signed [14:0] OUT;

reg [7:0] data_mem [0:19];

integer i, j;
integer file;

TPO u_TPO(.clk(clk),
	      .rst(rst),
	      .en(en),
	      .Din(Din),
	      .mode(2),
	      .OUT(OUT));

initial begin
	$readmemb(`PAT3, data_mem);
end

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	rst = 1'b1;
	#(`CYCLE*3); @(negedge clk) rst = 1'b0;
	Din = data_mem[0];
	@(posedge clk) en = 1'b1;
    for(i = 1; i < 20; i = i + 1) begin
    	@(negedge clk) Din = data_mem[i];
    	#(`CYCLE);
    end
end

initial begin
    file = $fopen("D:/William/Course/Base_Band/Lab05/Matlab/tpo_u3_out.txt", "w");
	#(`CYCLE*300);
	$fclose(file);
end

initial begin
    #(`CYCLE*6); 
	for(j = 0; j < 19; j = j + 1) begin
		$display("%b", OUT);
		$fwrite(file, "%d\n", OUT);
		#(`CYCLE*1);
	end
end

initial begin
	#(`End_CYCLE);
	$finish;
end

endmodule