// `include "D:/William/Course/Base_Band/Lab02/SYN.v"

module USI(clk, rst, en, lf_in, hf_out);
input clk, rst, en;
input [1:0] lf_in;
output reg [1:0] hf_out;
//
reg [1:0] switch;
// wire Q;

// SYN u_SYN(.clk(clk),
// 	      .rst(rst),
// 	      .D(lf_in[1]),
// 	      .Q(Q)
// 	      );

// Sample input every 4 cycles
always @(posedge clk or posedge rst) begin
	if (rst) begin
	    switch <= 2'd0;
	end
	else if(en) begin
		if(switch == 2'd3) begin
			switch <= 2'd0;
		end
		else begin
			switch <= switch + 2'd1;
		end
	end
	else begin
		switch <= switch;
	end
end

// Up-sampling
always @(posedge clk or posedge rst) begin
 	if (rst) begin
 	    hf_out <= 2'd0;
 	end
 	else if(en) begin
 		if(switch == 2'd2) begin
 			hf_out <= lf_in;
 		end
 		else begin
 			hf_out <= 2'd0;
 		end
 	end
 	else begin
 		hf_out <= hf_out;
 	end
 end 


endmodule