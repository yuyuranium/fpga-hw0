module PE(
input clk,
input rst,
input [0:1] stage,
input [0:3] x,
input [0:3] y,
input [0:3] x1,
input [0:3] y1,
input [0:3] r,
output reg res
    );

reg [0:8] data1;
reg [0:8] data2;
reg [0:8] data3;
reg [0:8] data4;
reg PE_mode;
reg [0:8] reg1;
reg [0:8] reg2;
reg [0:8] reg3;

wire [0:8] tmp = (PE_mode)? data1+data2 : data1-data2;
wire [0:8] tmp1 = data3*data4;

always@(*)begin
    case(stage)
        2'd0:begin
            PE_mode = 0;
            data1 = x;
            data2 = x1;
            data3 = tmp;
            data4 = tmp;
        end
        2'd1:begin
            PE_mode = 0;
            data1 = y;
            data2 = y1;
            data3 = tmp;
            data4 = tmp;
        end
        2'd2:begin
            PE_mode = 1;
            data1 = reg1;
            data2 = reg2;
            data3 = r;
            data4 = r;
        end
        2'd3:begin
            PE_mode = 1;
            data1 = reg3;
            data2 = ~reg1;
        end
        endcase
end

always@(posedge clk or posedge rst)begin
if(rst) begin
    reg1 <= 0; reg2 <= 0; reg3 <= 0; res <=0;
end
else begin
    if(stage == 2'd0) begin // (x-x1)^2
        reg1 <= tmp1; 
        res <= 0;
    end
    else if(stage == 2'd1) begin  // (y-y1)^2
        reg2 <= tmp1;
    end
    else if(stage == 2'd2) begin
        reg3 <= tmp;
        reg1 <= tmp1;
    end
    else begin 
        res <= tmp[0];
        reg1 <= 0; reg2 <= 0; reg3 <= 0;
    end
end
end

endmodule