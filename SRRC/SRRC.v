`timescale 1ns/10ps
// `include "D:/William/Course/Base_Band/Lab02/SRRC/DFF.v"
// `include "D:/William/Course/Base_Band/Lab02/SRRC/FA.v"

module SRRC(clk, rst, en, Din, Dout);
input clk, rst, en;
input [1:0] Din;
output [17:0] Dout;

wire signed [15:0] din;
wire signed [15:0] m [0:32];
wire [17:0] q [0:31]; 
wire [17:0] sum [0:31];

assign din = {Din, 14'd0};

// Coefficint_0: -0.010271 / 00_000000_(-1)0(-1)0_(-1)000
assign m[0] = ~((din >>> 7) + (din >>> 9) + (din >>> 11)) + 1;

// Coefficint_1: -0.003301 / 00_000000_0(-1)00_1010
assign m[1] = ~((din >>> 8) + (din >>> 11) + (din >>> 13)) + 1;

// Coefficint_2: 0.011274 / 00_000001_0(-1)00_(-1)001
assign m[2] = (din >>> 6) - (din >>> 8) - (din >>> 11) + (din >>> 14);

// Coefficint_3: 0.016275 / 00_000001_0001_0(-1)0(-1)
assign m[3] = (din >>> 6) + (din >>> 10) - (din >>> 12) - (din >>> 14);

// Coefficint_4: 0.002225 / 00_000000_0010_0100
assign m[4] = (din >>> 9) + (din >>> 12);

// Coefficint_5: -0.016874 / 00_00000(-1)_000(-1)_0(-1)00
assign m[5] = ~((din >>> 6) + (din >>> 10) + (din >>> 12)) + 1;

// Coefficint_6: -0.014225 / 00_00000(-1)_0010_(-1)00(-1)
assign m[6] = ~((din >>> 6) - (din >>> 9) + (din >>> 11) + (din >>> 14)) + 1;

// Coefficint_7: 0.016997 / 00_000001_0010_(-1)0(-1)0
assign m[7] = (din >>> 6) + (din >>> 9) - (din >>> 11) - (din >>> 13);

// Coefficint_8: 0.043247 / 00_00010(-1)_0(-1)00_0101
assign m[8] = (din >>> 4) - (din >>> 6) - (din >>> 8) + (din >>> 11) + (din >>> 14);

// Coefficint_9: 0.014549 / 00_000001_000(-1)_00(-1)0
assign m[9] = (din >>> 6) - (din >>> 10) - (din >>> 13);

// Coefficint_10: -0.077038 / 00_000(-1)0(-1)_0001_0010
assign m[10] = ~((din >>> 4) + (din >>> 6) - (din >>> 10) - (din >>> 13)) + 1;

// Coefficint_11: -0.158173 / 00_00(-1)0(-1)0_00(-1)0_0000
assign m[11] = ~((din >>> 3) + (din >>> 5) + (din >>> 9)) + 1;

// Coefficint_12: -0.105592 / 00_00(-1)001_0100_00(-1)0
assign m[12] = ~((din >>> 3) - (din >>> 6) - (din >>> 8) + (din >>> 13)) + 1;

// Coefficint_13: 0.158548 / 00_001010_0010_10(-1)0
assign m[13] = (din >>> 3) + (din >>> 5) + (din >>> 9) + (din >>> 11) - (din >>> 13);

// Coefficint_14: 0.579753 / 00_100101_0010_0(-1)0(-1)
assign m[14] = (din >>> 1) + (din >>> 4) + (din >>> 6) + (din >>> 9) - (din >>> 12) - (din >>> 14);

// Coefficint_15: 0.973987 / 01_0000(-1)0_10(-1)0_(-1)0(-1)0
assign m[15] = din - (din >>> 5) + (din >>> 7) - (din >>> 9) - (din >>> 11) - (din >>> 13);

// Coefficint_16: 1.135254 / 01_001000_1010_1000
assign m[16] = din + (din >>> 3) + (din >>> 7) + (din >>> 9) - (din >>> 11);

// Coefficint_17: 0.973987 / 010000(-1)010(-1)0(-1)0(-1)0
assign m[17] = din - (din >>> 5) + (din >>> 7) - (din >>> 9) - (din >>> 11) - (din >>> 13);

// Coefficint_18: 0.579753 / 0010010100100(-1)0(-1)
assign m[18] = (din >>> 1) + (din >>> 4) + (din >>> 6) + (din >>> 9) - (din >>> 12) - (din >>> 14);

// Coefficint_19: 0.158548 / 00001010001010(-1)0
assign m[19] = (din >>> 3) + (din >>> 5) + (din >>> 9) + (din >>> 11) - (din >>> 13);

// Coefficint_20: -0.105592 / 1_0000(-1)001010000(-1)0
assign m[20] = ~((din >>> 3) - (din >>> 6) - (din >>> 8) + (din >>> 13)) + 1;

// Coefficint_21: -0.158173 / 1_0000(-1)0(-1)000(-1)00000
assign m[21] = ~((din >>> 3) + (din >>> 5) + (din >>> 9)) + 1;

// Coefficint_22: -0.077038 / 1_00000(-1)0(-1)00010010
assign m[22] = ~((din >>> 4) + (din >>> 6) - (din >>> 10) - (din >>> 13)) + 1;

// Coefficint_23: 0.014549 / 00000001000(-1)00(-1)0
assign m[23] = (din >>> 6) - (din >>> 10) - (din >>> 13);

// Coefficint_24: 0.043247 / 0000010(-1)0(-1)000101
assign m[24] = (din >>> 4) - (din >>> 6) - (din >>> 8) + (din >>> 11) + (din >>> 14);

// Coefficint_25: 0.016997 / 000000010010(-1)0(-1)0
assign m[25] = (din >>> 6) + (din >>> 9) - (din >>> 11) - (din >>> 13);

// Coefficint_26: -0.014225 / 1_0000000(-1)0010(-1)00(-1)
assign m[26] = ~((din >>> 6) - (din >>> 9) + (din >>> 11) + (din >>> 14)) + 1;

// Coefficint_27: -0.016874 / 1_0000000(-1)000(-1)0(-1)00
assign m[27] = ~((din >>> 6) + (din >>> 10) + (din >>> 12)) + 1;

// Coefficint_28: 0.002225 / 0000000000100100
assign m[28] = (din >>> 9) + (din >>> 12);

// Coefficint_29: 0.016275 / 0000000100010(-1)0(-1)
assign m[29] = (din >>> 6) + (din >>> 10) - (din >>> 12) - (din >>> 14);

// Coefficint_30: 0.011274 / 000000010(-1)00(-1)001
assign m[30] = (din >>> 6) - (din >>> 8) - (din >>> 11) + (din >>> 14);

// Coefficint_31: -0.003301 / 1_000000000(-1)001010
assign m[31] = ~((din >>> 8) + (din >>> 11) + (din >>> 13)) + 1;

// Coefficint_32: -0.010271 / 1_00000000(-1)0(-1)0(-1)000
assign m[32] = ~((din >>> 7) + (din >>> 9) + (din >>> 11)) + 1;

DFF u_DFF0 (.clk(clk), .rst(rst), .D(sum[1]), .Q(q[0]));
DFF u_DFF1 (.clk(clk), .rst(rst), .D(sum[2]), .Q(q[1]));
DFF u_DFF2 (.clk(clk), .rst(rst), .D(sum[3]), .Q(q[2]));
DFF u_DFF3 (.clk(clk), .rst(rst), .D(sum[4]), .Q(q[3]));
DFF u_DFF4 (.clk(clk), .rst(rst), .D(sum[5]), .Q(q[4]));
DFF u_DFF5 (.clk(clk), .rst(rst), .D(sum[6]), .Q(q[5]));
DFF u_DFF6 (.clk(clk), .rst(rst), .D(sum[7]), .Q(q[6]));
DFF u_DFF7 (.clk(clk), .rst(rst), .D(sum[8]), .Q(q[7]));
DFF u_DFF8 (.clk(clk), .rst(rst), .D(sum[9]), .Q(q[8]));
DFF u_DFF9 (.clk(clk), .rst(rst), .D(sum[10]), .Q(q[9]));
DFF u_DFF10 (.clk(clk), .rst(rst), .D(sum[11]), .Q(q[10]));
DFF u_DFF11 (.clk(clk), .rst(rst), .D(sum[12]), .Q(q[11]));
DFF u_DFF12 (.clk(clk), .rst(rst), .D(sum[13]), .Q(q[12]));
DFF u_DFF13 (.clk(clk), .rst(rst), .D(sum[14]), .Q(q[13]));
DFF u_DFF14 (.clk(clk), .rst(rst), .D(sum[15]), .Q(q[14]));
DFF u_DFF15 (.clk(clk), .rst(rst), .D(sum[16]), .Q(q[15]));
DFF u_DFF16 (.clk(clk), .rst(rst), .D(sum[17]), .Q(q[16]));
DFF u_DFF17 (.clk(clk), .rst(rst), .D(sum[18]), .Q(q[17]));
DFF u_DFF18 (.clk(clk), .rst(rst), .D(sum[19]), .Q(q[18]));
DFF u_DFF19 (.clk(clk), .rst(rst), .D(sum[20]), .Q(q[19]));
DFF u_DFF20 (.clk(clk), .rst(rst), .D(sum[21]), .Q(q[20]));
DFF u_DFF21 (.clk(clk), .rst(rst), .D(sum[22]), .Q(q[21]));
DFF u_DFF22 (.clk(clk), .rst(rst), .D(sum[23]), .Q(q[22]));
DFF u_DFF23 (.clk(clk), .rst(rst), .D(sum[24]), .Q(q[23]));
DFF u_DFF24 (.clk(clk), .rst(rst), .D(sum[25]), .Q(q[24]));
DFF u_DFF25 (.clk(clk), .rst(rst), .D(sum[26]), .Q(q[25]));
DFF u_DFF26 (.clk(clk), .rst(rst), .D(sum[27]), .Q(q[26]));
DFF u_DFF27 (.clk(clk), .rst(rst), .D(sum[28]), .Q(q[27]));
DFF u_DFF28 (.clk(clk), .rst(rst), .D(sum[29]), .Q(q[28]));
DFF u_DFF29 (.clk(clk), .rst(rst), .D(sum[30]), .Q(q[29]));
DFF u_DFF30 (.clk(clk), .rst(rst), .D(sum[31]), .Q(q[30]));
DFF u_DFF31 (.clk(clk), .rst(rst), .D({m[32][15], m[32][15], m[32]}), .Q(q[31]));

FA u_FA0 (.in1(m[0]), .in2(q[0]), .out(sum[0]));
FA u_FA1 (.in1(m[1]), .in2(q[1]), .out(sum[1]));
FA u_FA2 (.in1(m[2]), .in2(q[2]), .out(sum[2]));
FA u_FA3 (.in1(m[3]), .in2(q[3]), .out(sum[3]));
FA u_FA4 (.in1(m[4]), .in2(q[4]), .out(sum[4]));
FA u_FA5 (.in1(m[5]), .in2(q[5]), .out(sum[5]));
FA u_FA6 (.in1(m[6]), .in2(q[6]), .out(sum[6]));
FA u_FA7 (.in1(m[7]), .in2(q[7]), .out(sum[7]));
FA u_FA8 (.in1(m[8]), .in2(q[8]), .out(sum[8]));
FA u_FA9 (.in1(m[9]), .in2(q[9]), .out(sum[9]));
FA u_FA10 (.in1(m[10]), .in2(q[10]), .out(sum[10]));
FA u_FA11 (.in1(m[11]), .in2(q[11]), .out(sum[11]));
FA u_FA12 (.in1(m[12]), .in2(q[12]), .out(sum[12]));
FA u_FA13 (.in1(m[13]), .in2(q[13]), .out(sum[13]));
FA u_FA14 (.in1(m[14]), .in2(q[14]), .out(sum[14]));
FA u_FA15 (.in1(m[15]), .in2(q[15]), .out(sum[15]));
FA u_FA16 (.in1(m[16]), .in2(q[16]), .out(sum[16]));
FA u_FA17 (.in1(m[17]), .in2(q[17]), .out(sum[17]));
FA u_FA18 (.in1(m[18]), .in2(q[18]), .out(sum[18]));
FA u_FA19 (.in1(m[19]), .in2(q[19]), .out(sum[19]));
FA u_FA20 (.in1(m[20]), .in2(q[20]), .out(sum[20]));
FA u_FA21 (.in1(m[21]), .in2(q[21]), .out(sum[21]));
FA u_FA22 (.in1(m[22]), .in2(q[22]), .out(sum[22]));
FA u_FA23 (.in1(m[23]), .in2(q[23]), .out(sum[23]));
FA u_FA24 (.in1(m[24]), .in2(q[24]), .out(sum[24]));
FA u_FA25 (.in1(m[25]), .in2(q[25]), .out(sum[25]));
FA u_FA26 (.in1(m[26]), .in2(q[26]), .out(sum[26]));
FA u_FA27 (.in1(m[27]), .in2(q[27]), .out(sum[27]));
FA u_FA28 (.in1(m[28]), .in2(q[28]), .out(sum[28]));
FA u_FA29 (.in1(m[29]), .in2(q[29]), .out(sum[29]));
FA u_FA30 (.in1(m[30]), .in2(q[30]), .out(sum[30]));
FA u_FA31 (.in1(m[31]), .in2(q[31]), .out(sum[31]));

assign Dout = sum[0];

endmodule