`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2024 16:02:58
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
    input [3:0] sw,
    input [2:0] btn,
    output reg [10:0] led,
    output reg [7:0] seg,
    output reg [3:0] an
    );

    parameter MAX_LED = 10;
    parameter MAX_COUNT_THREE_SECONDS = 300_000_000;
    wire subtask_A_clk;
    wire one_hz_clk;
    wire ten_hz_clk;
    wire hundred_hz_clk;
    wire five_thousandth_seconds_clk;
    wire five_hundredth_clk;
    wire point_five_seconds_clk;
    wire [3:0] subtask_A_count;
    wire [1:0] subtask_B_state;
    reg [1:0] completion_flags;
    reg display_toggle;
    wire [7:0] display_seg;
    wire [3:0] display_an;
    reg [3:0] subtask_B_count;
    reg reset_sw15_count;
    wire [31:0] sw15_count;

    display_module display(.clk(display_toggle),
                           .seg(display_seg),
                           .an(display_an),
                           .count(subtask_B_state));
    
    //posedge sub_A_clk == 1b'1 every 1.2s
    clock_module one_point_two_seconds_tick(.clk(clk), 
                                        .m(59_999_999), 
                                        .out(subtask_A_clk));

    four_bit_counter_module count_to_ten(.clk(subtask_A_clk),
                                         .max(MAX_LED),
                                         .count(subtask_A_count));

    clock_module one_hz_tick(.clk(clk), 
                             .m(49_999_999), 
                             .out(one_hz_clk));
    
    clock_module ten_hz_tick(.clk(clk), 
                             .m(4_999_999), 
                             .out(ten_hz_clk));
    
    clock_module hundred_hz_tick(.clk(clk), 
                                 .m(499_999), 
                                 .out(hundred_hz_clk));

    clock_module five_thousandth_seconds_tick(.clk(clk), 
                                        .m(249_999), 
                                        .out(five_thousandth_seconds_clk));
    
    clock_module five_hundredth_tick(.clk(clk), 
                                        .m(2_499_999), 
                                        .out(five_hundredth_clk));
    
    clock_module point_five_seconds_tick(.clk(clk), 
                                        .m(24_999_999), 
                                        .out(point_five_seconds_clk));

    counter_with_reset_module count_to_three(.clk(clk),
                                         .max(MAX_COUNT_THREE_SECONDS),
                                         .count(sw15_count),
                                         .reset(reset_sw15_count));
                                        

    always @ (posedge display_toggle) begin
        subtask_B_count = (subtask_B_count == 3) ? 3 : subtask_B_count + 1;
    end

    always @ (btn, sw) begin
        // 0 -> d
        // 1 -> l
        // 2 -> r
        if (!completion_flags[1] && display_toggle) 
            display_toggle = 0;
        
        if (subtask_B_count < 3 && completion_flags[0])
            if ((btn[0] == 1 && subtask_B_state == 2'b00) ||
                (btn[1] == 1 && subtask_B_state == 2'b01) ||
                (btn[2] == 1 && subtask_B_state == 2'b10))
                display_toggle = 1;
        
        if (completion_flags[1])
            display_toggle = sw[2] ? five_thousandth_seconds_clk
                                           : (sw[1] ? five_hundredth_clk
                                                    : (sw[0] ? point_five_seconds_clk
                                                             : 0));

        completion_flags[1] = (subtask_B_count == 3);
    end
    
    // LED Handler
    always @ (completion_flags[0]) begin
        if (sw15_count >= MAX_COUNT_THREE_SECONDS)
            led[9:0] = 10'b01_1010_0010;
        
        else if (!completion_flags[0])
            {led[9:0], completion_flags[0]} = {((10'b1 << subtask_A_count) - 10'b1),
                                                (subtask_A_count == MAX_LED)};

        else if (completion_flags[0])
            led[9:0] = { {7 {1'b1}}, sw[2] ? {hundred_hz_clk, 2'b11}
                                           : (sw[1] ? {1'b1, ten_hz_clk, 1'b1}
                                                    : (sw[0] ? {2'b11, one_hz_clk}
                                                             : 3'b111))};
        
        led[10] = ~(sw15_count >= MAX_COUNT_THREE_SECONDS) && completion_flags[1];
    end

    // LED Handler
    always @ (display_seg, display_an) begin
        if (!completion_flags[0])
            {seg, an} = {8'b11111111, 4'b1111};

        else if (sw15_count >= MAX_COUNT_THREE_SECONDS)
            {seg, an} = {8'b11010101, 4'b0000};

        else
            {seg, an} = {display_seg, display_an};
    end

    // SW15 Toggle
    always @ (sw[3]) begin
        reset_sw15_count = ~sw[3];
    end

    
endmodule
