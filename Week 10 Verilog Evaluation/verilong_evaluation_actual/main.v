`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 00:37:15
// Design Name: 
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main(
    input clk,
    input [15:0] sw,
    output reg [15:0] led,
    output reg [6:0] seg,
    output reg dp,
    output reg [3:0] an,

    input btnC, 
    input btnU, 
    input btnL, 
    input btnR, 
    input btnD);

    constants_module constants();

    // wire clk_6p35;
    // clock_module_m clk_6p35_module (
    //     .clk(clk),
    //     .m(787_4015),
    //     .out(clk_6p35)
    // );

    wire TIME_R;
    clock_module_m TIME_R_module (
        .clk(clk),
        .m(24_499_999),
        .out(TIME_R)
    );

    reg [3:0] state = 7;
    reg [3:0] TIME_L = 0;
    reg go_right = 0;
    reg go_left = 0;
    // reg start_explore;

    always @ (posedge TIME_R) begin

        TIME_L <= (TIME_L >= 2) ? 0 : TIME_L + 1;

        if (!go_right && !go_left) begin
            state <= state;
        end
        
        if (go_right) begin
            state <= (state >= 14)
                ? 14
                : state + 1;
        end
        else if (go_left && TIME_L == 2) begin
            state <= (state == 0)
                ? 0
                : state - 1;
        end
    end

    reg explore = 1;

    always @ (*) begin
        // LED Control
        led[9:0] <= !sw[1]
            ? {10 {1'b1}}
            : 10'b0110_10011_1;
    
        // Init (Subtask A)
        if (!sw[15]) begin
            dp <= 1;
            seg <= constants.SEG_DIGIT_8;
            an <= 4'b0110;
        end

        // Explore (Subtask B)
        else begin
            dp <= 1;
            seg <= 7'b1111101;
            an <= 4'b1101;
        
        end
    end

endmodule
