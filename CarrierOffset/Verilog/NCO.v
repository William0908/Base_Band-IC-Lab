module NCO(clk, rst, en, ncos, nsin);
input clk, rst, en;
output [11:0] ncos, nsin;

reg [9:0] addr;
wire [11:0] cos_rom, sin_rom;

ROM_COS u_ROM_COS(.clka(clk),
	              .addra(addr),
	              .douta(cos_rom),
	              .ena(1)
	              );

ROM_SINE u_ROM_SINE(.clka(clk),
	               .addra(addr),
	               .douta(sin_rom),
	               .ena(1)
	               );

// Address
always @(posedge clk or posedge rst) begin
	if (rst) begin
	    addr <= 10'd0;
	end
	else if(en) begin
		addr <= addr + 10'd1;
	end
	else begin
		addr <= addr;
	end
end

assign ncos = cos_rom;
assign nsin = sin_rom;

endmodule