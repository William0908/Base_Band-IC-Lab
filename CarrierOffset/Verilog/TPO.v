module TPO(clk, rst, en, Din, mode, OUT);
input clk, rst, en;
input signed [7:0] Din;
input [1:0] mode;
output reg signed [14:0] OUT;

reg [12:0] Din_temp;
reg [12:0] Din_buffer;
wire [13:0] out_temp;

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    Din_temp <= 8'd0;
	end
	else if(en) begin
		Din_temp <= {Din, 5'd0};
	end
	else begin
		Din_temp <= Din_temp;
	end
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    Din_buffer <= 8'd0;
	end
	else if(en) begin
		Din_buffer <= Din_temp;
	end
	else begin
		Din_buffer <= Din_buffer;
	end
end

assign out_temp = {Din_temp[12], Din_temp} + (~({Din_buffer[12], Din_buffer}) + 1);

always @(posedge clk or posedge rst) begin
	if (rst) begin
	    OUT <= 15'd0;
	end
	else if(en) begin
		case(mode)
		     0: begin
		     	OUT <= {Din_buffer[12], Din_buffer[12], Din_buffer} + (({out_temp[13], out_temp} >>> 4) + ({out_temp[13], out_temp} >>> 5));
		     end
		     1: begin
		     	OUT <= {Din_buffer[12], Din_buffer[12], Din_buffer} + (out_temp >>> 2) + (out_temp >>> 5);
		     end
		     2: begin
		     	OUT <= {Din_buffer[12], Din_buffer[12], Din_buffer} + (out_temp >>> 1);
		     end
		     default: begin
		     	OUT <= OUT;
		     end
		endcase
	end
	else begin
		OUT <= OUT;
	end
end

endmodule