module Controller( clk,
                   rst,
                   en,
                   busy,
                   x,
                   y,
                   stage,
                   analyze_en,
                   valid                
                 );

input clk,rst;
input en;
output reg busy;
output [3:0] x,y;
output [1:0] stage;
output analyze_en;
output valid;

parameter IDLE=3'd0,
          RECV=3'd1,
          PROCESS=3'd2,
          ANALYZE=3'd3,
          DONE=3'd4;

reg [2:0] state, n_state;
reg [3:0] coordinate_x, coordinate_y;
reg [3:0] next_x,next_y;
reg [1:0] process_cnt, next_cnt;



assign x=coordinate_x;
assign y=coordinate_y;
assign analyze_en=(state==ANALYZE)?1'b1:1'b0; // if analyze enable then do accumulate
assign stage=process_cnt; //process stage
assign valid=(state==DONE)?1'b1:1'b0; //valid signal

// FSM
always@(posedge clk or posedge rst)begin
    if(rst)begin
        state<=IDLE;
    end
    else begin
        state<=n_state;
    end
end
always@(*)begin
    case(state)
        IDLE:begin
            if(en)begin
                n_state=RECV;
            end
            else begin
                n_state=IDLE;
            end
        end
        RECV:begin
            n_state=PROCESS;
        end
        PROCESS:begin
            if(process_cnt==2'd3)begin
                n_state=ANALYZE;
            end
            else begin
                n_state=PROCESS;
            end
        end
        ANALYZE:begin
            if(x==4'd8 && y==4'd8)begin
                n_state=DONE;
            end
            else begin
                n_state=PROCESS;
            end
        end
        DONE:begin
            n_state=IDLE;
        end
        default:begin
            n_state=IDLE;
        end
    endcase
end

// x,y
always@(posedge clk or posedge rst)begin
    if(rst)begin
        coordinate_x<=4'd1;
        coordinate_y<=4'd1;
    end
    else begin
        coordinate_x<=next_x;
        coordinate_y<=next_y;
    end
end
always@(*)begin
    if(state==ANALYZE)begin
        if(coordinate_x==4'd8 &&coordinate_y==4'd8)begin
            next_x=4'd1;
            next_y=4'd1;
        end
        else if(coordinate_y==4'd8)begin
            next_x=coordinate_x+4'd1;
            next_y=4'd1;
        end
        else begin
            next_x=coordinate_x;
            next_y=coordinate_y+4'd1;
        end
    end
    else begin
        next_x=coordinate_x;
        next_y=coordinate_y;
    end
end

// process_cycle
always@(posedge clk or posedge rst)begin
    if(rst)begin
        process_cnt<=2'd0;
    end
    else begin
        process_cnt<=next_cnt;
    end
end
always@(*)begin
    if(state==PROCESS)begin
        if(process_cnt==2'd3)begin
            next_cnt=2'd0;
        end
        else begin
            next_cnt=process_cnt+2'd1;
        end
    end
    else begin
        next_cnt=2'd0;
    end
end

always@(*)begin
    case(state)
        IDLE:begin
            busy=1'b0;
        end
        RECV:begin
            busy=1'b0;
        end
        PROCESS:begin
            busy=1'b1;
        end
        ANALYZE:begin
            busy=1'b1;
        end
        DONE:begin
            busy=1'b1;
        end
        default:begin
            busy=1'b0;
        end
    endcase
end


endmodule
