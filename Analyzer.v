module Analyzer(
input clk,
input rst,
input en,
input analyze_en,
input [1:0] mode,
input A,
input B,
input C,
output reg [6:0] res
    );

wire w1, w2, w3, w4, w5, w6;

//mode==01
and g1(w1, A, B);
//mode==10
xor g2(w2, A, B);
//mode==11
and g3(w3, ~A, B ,C);
and g4(w4, A, ~B, C);
and g5(w5, A, B, ~C);
or g6(w6, w3, w4, w5);

always@(posedge clk, posedge rst)begin
if(rst || !en)begin
    res <= 0;
end
else begin
    if (analyze_en) begin
        case(mode)
           2'd0:begin
               res <= res + A;
           end
           2'd1:begin
               res <= res + w1;
           end
           2'd2:begin
               res <= res + w2;
           end
           2'd3:begin
               res <= res + w6;
           end
    endcase
    end
    else res <= res;
end
end


endmodule
