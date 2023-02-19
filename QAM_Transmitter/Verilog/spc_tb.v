`timescale 1ns/10ps
`define CYCLE 20

module spc_tb;
reg clk = 0;
reg rst = 0;
reg en = 0;
reg Din;
reg [10:0] cycle = 0;
reg data_mem[0:1023];
reg [1:0] golden [0:511];
reg flag = 0;
reg [9:0] pass = 0;
wire [1:0] OUT;

integer i;
integer count = 0;

SPC u_SPC (.clk(clk),
	       .rst(rst),
	       .en(en),
	       .Din(Din),
	       .OUT(OUT)
	       );

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	$readmemb("data_in_1024_bin.txt", data_mem);
	$readmemb("golden_1024_bin.txt", golden);
end

initial begin
	rst = 1'b1;
	en = 1'b0; 
    #(`CYCLE*10); rst = 1'b0;
    en = 1'b1;
    for(i = 0; i < 1024; i = i + 1) begin
    	@(negedge clk) Din = data_mem[i];
    	#(`CYCLE*1);
    end
    #(`CYCLE*2000); 
    $finish;
end

always @(posedge clk) begin
	cycle = cycle + 1;
	if (cycle > 2000) $finish;
end

always@(posedge clk) begin #(`CYCLE*1) flag = ~flag; end

always @(negedge clk) begin
	if (en && flag) begin
	    if(OUT == golden[count - 1]) begin
	    	pass = pass + 1;
	    end
	    count = count + 1;
	end
	if(cycle == 1050) begin
		if(pass == 512) $display("ALL PASS !!");
	    else $display("FAIL");
	end
end

endmodule