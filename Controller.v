module Controller( clk,
                   rst,
                   busy,
                   x,
                   y,
                   stage,
                   analyze_en,
                   valid                
                 );

input clk,rst;
output busy;
output [3:0] x,y;
output [1:0] stage;
output analyze_en;
output valid;

parameter IDLE=2'd0,
          PROCESS=2'd1,
          ANALYZE=2'd2,
          DONE=2'd3;

reg [1:0] state, n_state;
reg [3:0] coordinate_x, coordinate_y;
reg [3:0] next_x,next_y;
reg [1:0] process_cnt, next_cnt;



assign x=coordinate_x;
assign y=coordinate_y;
assign analyze_en=(state==ANALYZE)?1'b1:1'b0; // if analyze enable then do accumulate
assign stage=process_cnt; //process stage
assign busy=(state==IDLE)?1'b0:1'b1; //busy signal
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



endmodule
