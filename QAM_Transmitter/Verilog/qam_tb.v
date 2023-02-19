`timescale 1ns/10ps
`define CYCLE 10
`define CYCLE_2 20
`define End_CYCLE 100000

`define PAT "D:/William/Course/Base_Band/Lab02/Matlab/data_in_1024_bin.txt"

module qam_tb;
reg clk = 0;
reg clk_2 = 0;
reg rst = 0;
reg en = 0;
reg Din;
wire signed [17:0] IFout;

reg data_mem [0:1023];

integer i, j;

integer file, file1;

QAM u_QAM(.clk(clk),
	      .clk_2(clk_2),
	      .rst(rst),
	      .en(en),
	      .Din(Din),
	      .IFout(IFout)
	      );

initial begin
	$readmemb(`PAT, data_mem);
end

always begin #(`CYCLE/2) clk = ~clk; end

always begin #(`CYCLE_2/2) clk_2 = ~clk_2; end

initial begin
	@(posedge clk_2); rst = 1'b1;
	#(`CYCLE_2*2); @(negedge clk_2); rst = 1'b0;
	@(posedge clk_2); en = 1'b1;
	for(i = 0; i < 1024; i = i + 1) begin
		@(negedge clk_2) Din = data_mem[i];
		#(`CYCLE_2*1);
	end
end

initial begin
    file = $fopen("D:/William/Course/Base_Band/Lab02/Matlab/IFout_dec.txt", "w");
    file1 = $fopen("D:/William/Course/Base_Band/Lab02/Matlab/IFout_bin.txt", "w");
	#(`CYCLE*5000);
	$fclose(file);
	$fclose(file1);
end

initial begin
    #(`CYCLE*15); 
	for(j = 0; j < 2048; j = j + 1) begin
	    #(`CYCLE*1);
		$display("%b", IFout);
		$fwrite(file, "%d\n", IFout);
		$fwrite(file1, "%b\n", IFout);
	end
end

initial  begin
 #`End_CYCLE ;
 	$finish;
end

endmodule