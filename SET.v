`include "PE.v"
`include "Analyzer.v"
`include "Controller.v"

module SET (
    input        clk,
    input        rst,
    input        en,
    input [23:0] central,
    input [11:0] radius,
    input [1:0]  mode,
    output       busy,
    output       valid,
    output [7:0] candidate
);

    reg  [3:0] x_a, y_a, x_b, y_b, x_c, y_c;
    reg  [3:0] r_a, r_b, r_c;
    wire [1:0] stage;
    wire [3:0] x, y;
    wire a, b, c;
    wire analyze_en;

    /* Registers for mode, central and radius of A, B and C */
    always @(posedge clk or posedge rst) begin
        if (rst || en) begin
            x_a <= 3'd0;
            y_a <= 3'd0;
            x_b <= 3'd0;
            y_b <= 3'd0;
            x_c <= 3'd0;
            y_c <= 3'd0;
            r_a <= 3'd0;
            r_b <= 3'd0;
            r_c <= 3'd0;
        end else begin
            if (en) begin
                x_a <= central[23:20];
                y_a <= central[19:16];
                x_b <= central[15:12];
                y_b <= central[11:8];
                x_c <= central[7:4]; 
                y_c <= central[3:0];
                r_a <= radius[11:8];
                r_b <= radius[7:4];
                r_c <= radius[3:0];
            end
        end
    end

    Controller ctrl(
        .clk(clk),
        .rst(rst),
        .busy(busy),
        .x(x),
        .y(y),
        .stage(stage),
        .analyze_en(analyze_en),
        .valid(valid)
    );

    PE pe_a(
        .clk(clk),
        .rst(rst),
        .stage(stage),
        .x(x),
        .y(y),
        .x1(x_a),
        .y1(y_a),
        .r(r_a),
        .res(a)
    );

    PE pe_b(
        .clk(clk),
        .rst(rst),
        .stage(stage),
        .x(x),
        .y(y),
        .x1(x_b),
        .y1(y_b),
        .r(r_b),
        .res(b)
    );

    PE pe_c(
        .clk(clk),
        .rst(rst),
        .stage(stage),
        .x(x),
        .y(y),
        .x1(x_c),
        .y1(y_c),
        .r(r_c),
        .res(c)
    );

    Analyzer analyzer(
        .clk(clk),
        .rst(rst),
        .en(en),
        .analyze_en(analyze_en),
        .mode(mode),
        .A(a),
        .B(b),
        .C(c),
        .res(candidate)
    );

endmodule
