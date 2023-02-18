module FA(in1, in2, out);
input signed [15:0] in1;
input signed [17:0] in2;
output signed [17:0] out;

assign out = in1 + in2;

endmodule