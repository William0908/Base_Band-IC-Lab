`timescale 1ns/10ps
`define CYCLE 20
`define End_CYCLE 100000 

`define DPAT "D:/William/Course/Base_Band/Lab02/Matlab/golden_1024_bin.txt"
`define IPAT "D:/William/Course/Base_Band/Lab02/Matlab/I_1024_bin.txt"
`define QPAT "D:/William/Course/Base_Band/Lab02/Matlab/Q_1024_bin.txt"

module sm_tb;
reg clk = 0;
reg rst = 0;
reg en = 0;
reg [1:0] Din;
wire [1:0] I;
wire [1:0] Q;

reg [1:0] data_mem [0:511];
reg [1:0] I_mem [0:511];
reg [1:0] Q_mem [0:511]; 

reg [8:0] check, pass , fail; 

integer i, j;

SM u_SM(.clk(clk),
	    .rst(rst),
	    .en(en),
	    .Din(Din),
	    .I(I),
	    .Q(Q)
	    );

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
    $readmemb(`DPAT, data_mem);
	$readmemb(`IPAT, I_mem);
	$readmemb(`QPAT, Q_mem);
end

initial begin
	@(negedge clk) #1; rst = 1'b1;
	#(`CYCLE*3); #1; rst = 1'b0;
	Din = data_mem[0];
	en = 1'b1;
	for(i = 1; i < 512; i = i + 1) begin
		@(negedge clk) Din = data_mem[i];
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
    #(`CYCLE*5)
    check = 0;
    pass = 0;
    fail = 0;
	if(check < 511) begin
	    for(j = 0; j < 512; j = j + 1) begin
	        if(check == 511) check = 511; 
	        else check = check + 1;
	    	if(I == I_mem[j] && Q == Q_mem[j]) begin
	    		if(pass == 511) pass = 511; 
	    		else pass = pass + 1;
	    	end
	    	else begin
	    		fail = fail + 1;
	    	end
	    	$display("---------------------------------------------------------------------------\n");
	    	$display("Data: %d\n", j);
	    	$display("Output is : %b, %b\n", I, Q);
		    $display("Expected is : %b, %b\n", I_mem[j], Q_mem[j]);
		    $display("---------------------------------------------------------------------------\n");
		    #(`CYCLE);
	    end
	end
	if(check == 511) begin
	    if(pass == 511) begin
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
