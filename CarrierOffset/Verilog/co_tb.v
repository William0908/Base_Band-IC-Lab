`timescale 1ns/10ps
`define CYCLE 20
`define End_CYCLE 100000

`define IPAT "D:/William/Course/Base_Band/Lab02/Matlab/I_1024_bin.txt"
`define QPAT "D:/William/Course/Base_Band/Lab02/Matlab/Q_1024_bin.txt"
`define IR "D:/William/Course/Base_Band/Lab05/Matlab/I_rotate_bin.txt"
`define QR "D:/William/Course/Base_Band/Lab05/Matlab/Q_rotate_bin.txt"

module co_tb;
reg clk = 0;
reg rst = 0;
reg en = 0;
reg [1:0] I;
reg [1:0] Q;
wire [13:0] I_ro;
wire [13:0] Q_ro;

reg [1:0] I_mem [0:1023];
reg [1:0] Q_mem [0:1023];
reg signed [13:0] Ir_mem [0:1023];
reg signed [13:0] Qr_mem [0:1023];
reg [10:0] pass_i = 0;
reg [10:0] pass_q = 0;

integer i, j;

CO u_CO(.clk(clk),
	    .rst(rst),
	    .en(en),
	    .I(I),
	    .Q(Q),
	    .I_ro(I_ro),
	    .Q_ro(Q_ro)
	    );

initial begin
	$readmemb(`IPAT, I_mem);
	$readmemb(`QPAT, Q_mem);
	$readmemb(`IR, Ir_mem);
	$readmemb(`QR, Qr_mem);
end

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
	rst = 1'b1;
	I = I_mem[0];
	Q = Q_mem[0];
	#(`CYCLE*3) @(negedge clk) rst = 1'b0;
	@(posedge clk) en = 1'b1;
    for(i = 0; i < 1024; i = i + 1) begin
    	I = I_mem[i];
    	Q = Q_mem[i];
    	#(`CYCLE);
    end
end

initial begin
	#(`CYCLE*5);
	for(j = 0; j < 1024; j = j + 1) begin
		if(I_ro == Ir_mem[j]) begin
			$display("I %d is pass", j);
			pass_i = pass_i + 1;
		end
		if(Q_ro == Qr_mem[j]) begin
			$display("Q %d is pass", j);
			pass_q = pass_q + 1;
		end
		#(`CYCLE);
	end
	if(pass_i == 1024 && pass_q == 1024) begin
		$display("ALL PASS");
	end

end

initial begin
	#(`End_CYCLE);
	$finish;
end

endmodule