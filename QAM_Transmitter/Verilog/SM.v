module SM(clk, rst, en, Din, I, Q);
input clk, rst, en;
input [1:0] Din;
output reg [1:0] I;
output reg [1:0] Q;
//

// 4-QAM constellation mapping
always @(posedge clk or posedge rst) begin
      if (rst) begin
          I <= 2'b00;
          Q <= 2'b00; 
      end
      else if(en) begin
            case(Din)
             0: begin
                  I <= 2'b01;
                  Q <= 2'b01;
             end
             1: begin
                  I <= 2'b01;
                  Q <= 2'b11;
             end
             2: begin
                  I <= 2'b11;
                  Q <= 2'b01;
             end
             3: begin
                  I <= 2'b11;
                  Q <= 2'b11;
             end
             default : begin
                  I <= I;
                  Q <= Q;
             end
            endcase
      end
      else begin
            I <= I;
            Q <= Q;
      end
end

endmodule