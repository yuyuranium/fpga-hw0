module Analyzer(
input clk,
input rst,
input en,
input analyze_en,
input [1:0] mode,
input A,
input B,
input C,
output reg [7:0] res
    );

wire w1, w2, w3, w4, w5, w6;
reg [7:0] next_res, tmp;

//mode==01
and g1(w1, A, B);
//mode==10
xor g2(w2, A, B);
//mode==11
and g3(w3, ~A, B ,C);
and g4(w4, A, ~B, C);
and g5(w5, A, B, ~C);
or g6(w6, w3, w4, w5);

always@(*)begin
    case(mode)
        2'd0:tmp = A;
        2'd1:tmp = w1;
        2'd2:tmp = w2;
        2'd3:tmp = w6;
    endcase
    next_res = res + tmp;
end

always@(posedge clk, posedge rst)begin
if(rst || en)begin
    res <= 0;
end
else begin
    if (analyze_en) begin
        res <= next_res;
    end
    else res <= res;
end
end

endmodule
