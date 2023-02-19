`timescale 1ns/10ps
`include "D:/William/Course/Base_Band/Lab02/SPC/SPC.v"
`include "D:/William/Course/Base_Band/Lab02/SM/SM.v"
`include "D:/William/Course/Base_Band/Lab02/USI/USI.v"
`include "D:/William/Course/Base_Band/Lab02/SRRC/SRRC.v"
`include "D:/William/Course/Base_Band/Lab02/SRRC/DFF.v"
`include "D:/William/Course/Base_Band/Lab02/SRRC/FA.v"
`include "D:/William/Course/Base_Band/Lab02/SYN.v"

module QAM(clk, clk_2, rst, en, Din, IFout);
input clk, clk_2, rst, en;
input Din;
output reg signed [17:0] IFout;

// Port connection
wire [1:0] spc_out;
wire [1:0] sm_i;
wire [1:0] sm_q;
wire [1:0] lf_i;
wire [1:0] lf_q;
wire [1:0] usi_i;
wire [1:0] usi_q;
wire signed [17:0] srrc_i;
wire signed [17:0] srrc_q;
wire en0;
wire en1;
wire en2;
wire en3;
// SM
reg sm_ctrl;
// USI
reg [3:0] usi_ctrl;
// Mixer
reg [1:0] mix_cnt;

(* ASYNC_REG = "True" *) reg sync_i0, sync_i1, sync_q0, sync_q1;

assign en0 = en;

// Double flop synchronizer
always @(posedge clk or posedge rst) begin
	if (rst) begin
	    sync_i0 <= 1'd0;
	    sync_q0 <= 1'd0; 
	end
	else begin
		sync_i0 <= sm_i[1];
		sync_q0 <= sm_q[1];
	end
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    sync_i1 <= 1'd0;
	    sync_q1 <= 1'd0;
	end
	else begin
		sync_i1 <= sync_i0;
		sync_q1 <= sync_q0;
	end
end

// Signal mapping control
always @(posedge clk_2 or posedge rst) begin
	if (rst) begin
	    sm_ctrl <= 1'd0;
	end
	else begin
		sm_ctrl <= ~sm_ctrl;
	end
end

assign en1 = (sm_ctrl) ? 1'd1 : 1'd0;

// Up sampling control
always @(posedge clk or posedge rst) begin
	if (rst) begin
	    usi_ctrl <= 1'd0;
	end
	else if(en) begin
		if(usi_ctrl == 4'd8) usi_ctrl <= usi_ctrl;
		else usi_ctrl <= usi_ctrl + 4'd1;
	end
end

// assign en2 = (usi_ctrl) ? 1'd1 : 1'd0;
assign en2 = (usi_ctrl == 4'd8) ? 1'd1 : 1'd0;
assign en3 = 1'd1;

assign lf_i = {sync_i1, 1'd1};
assign lf_q = {sync_q1, 1'd1};

SPC u_SPC(.clk(clk_2),
	      .rst(rst),
	      .en(en0),
	      .Din(Din),
	      .OUT(spc_out)
	      );

SM u_SM(.clk(clk_2),
	    .rst(rst),
	    .en(en1),
	    .Din(spc_out),
	    .I(sm_i),
	    .Q(sm_q)
	    );

USI u_USI_i(.clk(clk),
	        .rst(rst),
	        .en(en2),
	        .lf_in(lf_i),
	        .hf_out(usi_i)
	        );

USI u_USI_q(.clk(clk),
	        .rst(rst),
	        .en(en2),
	        .lf_in(lf_q),
	        .hf_out(usi_q)
	        );

SRRC u_SRRC_i(.clk(clk),
	          .rst(rst),
	          .en(en3),
	          .Din(usi_i),
	          .Dout(srrc_i)
	          );

SRRC u_SRRC_q(.clk(clk),
	          .rst(rst),
	          .en(en3),
	          .Din(usi_q),
	          .Dout(srrc_q)
	          );

// Mixer counter
always @(posedge clk or posedge rst) begin
	if (rst) begin
	    mix_cnt <= 2'd0;
	end
	else if(en) begin
		if (mix_cnt == 2'd3) begin
			mix_cnt <= 2'd0;
		end
		else begin
			mix_cnt <= mix_cnt + 2'd1;
		end
	end
	else begin
		mix_cnt <= mix_cnt;
	end
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    IFout <= 18'd0;
	end
	else if(en2) begin
		case(mix_cnt)
             3: begin
             	IFout <= srrc_i;
             end
             0: begin
             	IFout <= ~(srrc_q) + 18'd1;
             end
             1: begin
             	IFout <= ~(srrc_i) + 18'd1;
             end
             2: begin
             	IFout <= srrc_q;
             end
             default: begin
             	IFout <= IFout;
             end
		endcase
	end
	else begin
		IFout <= IFout;
	end
end

endmodule