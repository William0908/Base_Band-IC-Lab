`timescale 1ns/10ps
`define CYCLE 4
`define End_CYCLE 100000

`define PAT "D:/William/Course/Base_Band/Lab02/Matlab/I_up_2048_bin.txt" 
// `define PAT "D:/William/Course/Base_Band/Lab02/Matlab/Q_up_2048_bin.txt"

module srrc_tb;
reg clk = 0;
reg rst = 0;
reg en = 0;
reg [1:0] Din;
wire [17:0] Dout;

reg [1:0] data_mem [0:2047];

integer i, j;
integer file, file1;

SRRC u_SRRC (.clk(clk),
	         .rst(rst),
	         .en(en),
	         .Din(Din),
	         .Dout(Dout)
	         );

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	$readmemb(`PAT, data_mem);
end

initial begin
	@(posedge clk) rst = 1;
	#(`CYCLE*3);
	@(negedge clk) rst = 0;
	en = 1'b1;
	//Din = data_mem[0];
	for(i = 0; i < 2048; i = i + 1) begin
		Din = data_mem[i];
		#(`CYCLE*1);
	end
end

initial begin
    file = $fopen("D:/William/Course/Base_Band/Lab02/Matlab/srrc_out_1024_dec_I.txt", "w");
    file1 = $fopen("D:/William/Course/Base_Band/Lab02/Matlab/srrc_out_1024_bin_I.txt", "w");
	#(`CYCLE*3000);
	$fclose(file);
	$fclose(file1);
end

initial begin
    #(`CYCLE*4); 
	for(j = 0; j < 2048; j = j + 1) begin
	    #(`CYCLE*1);
		$display("%b", Dout);
		$fwrite(file, "%d\n", Dout);
		$fwrite(file1, "%b\n", Dout);
	end
end

initial  begin
 #`End_CYCLE ;
 	$finish;
end

endmodule