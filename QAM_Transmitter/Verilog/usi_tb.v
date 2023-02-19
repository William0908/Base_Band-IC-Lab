`timescale 1ns/10ps
`define CYCLE 16
`define CYCLE_4 4
`define End_CYCLE 100000

`define IPAT "D:/William/Course/Base_Band/Lab02/Matlab/I_1024_bin.txt"
`define QPAT "D:/William/Course/Base_Band/Lab02/Matlab/Q_1024_bin.txt"
`define IUP "D:/William/Course/Base_Band/Lab02/Matlab/I_up_1024_bin.txt"
`define QUP "D:/William/Course/Base_Band/Lab02/Matlab/Q_up_1024_bin.txt"

module usi_tb;
reg clk = 0;
reg clk_4 = 0;
reg rst = 0;
reg en = 0;
reg [1:0] lf_in;
wire [1:0] hf_out;

reg [1:0] I_mem [0:511];
reg [1:0] Q_mem [0:511];
reg [1:0] I_up [0:2047];
reg [1:0] Q_up [0:2047];

reg [10:0] check, pass , fail; 

integer i, j;

USI u_USI(.clk(clk_4),
		  .rst(rst),
		  .en(en),
		  .lf_in(lf_in),
		  .hf_out(hf_out)
		  );

always begin #(`CYCLE/2) clk = ~clk; end

always begin #(`CYCLE_4/2) clk_4 = ~clk_4; end

initial begin
	$readmemb(`IPAT, I_mem);
	$readmemb(`QPAT, Q_mem);
	$readmemb(`IUP, I_up);
	$readmemb(`QUP, Q_up);
end

initial begin
	@(negedge clk_4); #1; rst = 1'b1;
	#(`CYCLE_4*3); #1; rst = 1'b0;
	en = 1'b1;
	lf_in = I_mem[0];
	for(i = 1; i < 512; i = i + 1) begin
		@(negedge clk_4); lf_in = I_mem[i];
		#(`CYCLE*1);
	end
end

initial  begin
 #`End_CYCLE ;
 	$display("-----------------------------------------------------\n");
 	$display("----------------Error!!! Can't Stop!!!---------------\n");
 	$display("-------------------------FAIL------------------------\n");
 	$display("-----------------------------------------------------\n");
 	$finish;
end

initial begin
    #(`CYCLE_4*7);
	check = 0;
	pass = 0;
	fail = 0;
	if(check < 2047) begin
		for(j = 0; j < 2048; j = j + 1) begin
			if(hf_out == I_up[j]) begin
				if(pass == 2047) begin
					pass = pass;
				end
				else begin
				 	pass = pass + 1;
				end 
				$display("Data %d is pass !!", j);
			end
			else begin
				if(fail == 2047) begin
					fail = fail;
				end
				else begin
				 	fail = fail + 1;
				end
				$display("Data %d is fail =( , %d/ %d", j, I_up[i], hf_out);
			end
			if(check == 2047) begin
				check = check;
			end
			else begin
				check = check + 1;
			end
			#(`CYCLE_4*1);
		end
	end
    if(check == 2047) begin
	    if(pass == 2047) begin
	    	$display("---------------------------------------------------------------------------\n");
 	        $display("-----------------------------Congratulation!!!-----------------------------\n");
 	        $display("-------------------------Simulation is ALL PASS !!!------------------------\n");
 	        $display("---------------------------------------------------------------------------\n");
 	        $finish;
	    end
	    else begin
	    	$display("Fail is : %d\n", fail);
	 	    $finish;
	    end
	end
end

endmodule 