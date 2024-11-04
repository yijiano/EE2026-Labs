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

    wire clk_1p2_Hz;
    clock_module_m clk_1p2_Hz_module(
        .clk(clk),
        .m(41_666_666),
        .out(clk_1p2_Hz)
    );

    wire clk_1_Hz;
    clock_module_f clk_1_Hz_module(
        .clk(clk),
        .f(1),
        .out(clk_1_Hz)
    );

    wire clk_10_Hz;
    clock_module_f clk_10_Hz_module(
        .clk(clk),
        .f(10),
        .out(clk_10_Hz)
    );

    wire clk_100_Hz;
    clock_module_f clk_100_Hz_module(
        .clk(clk),
        .f(100),
        .out(clk_100_Hz)
    );

    wire clk_2_Hz;
    clock_module_f clk_2_Hz_module(
        .clk(clk),
        .f(2),
        .out(clk_2_Hz)
    );

    wire clk_20_Hz;
    clock_module_f clk_20_Hz_module(
        .clk(clk),
        .f(20),
        .out(clk_20_Hz)
    );

    wire clk_200_Hz;
    clock_module_f clk_200_Hz_module(
        .clk(clk),
        .f(200),
        .out(clk_200_Hz)
    );
    

    wire [31:0] init_counter;
    counter_module init_counter_module(
        .clk(clk_1p2_Hz),
        .max(10),
        .count(init_counter)
    );

    reg is_done_init = 0;
    reg is_unlocked = 0;
    
    reg [2:0] button_state = 0;

    always @ (posedge clk_10_Hz) begin
        if (button_state == 0 && btnD) button_state <= button_state + 1;
        else if (button_state == 1 && btnL) button_state <= button_state + 1;
        else if (button_state == 2 && btnR) button_state <= button_state + 1;
        else button_state <= button_state;
    end
    
    always @ (*) begin
        is_done_init <= (init_counter == 10);
        is_unlocked <= button_state == 3;
    end

    reg [2:0] cycle_counter = 0;
    reg cycle_clk;
    always @ (posedge cycle_clk) begin
        cycle_counter <= ((cycle_counter >= 2) ? 0 : cycle_counter + 1);
    end

    wire [31:0] sw15_counter;
    reg sw15_reset;
    counter_module sw15_counter_module(
        .clk(clk),
        .max(300_000_000),
        .reset(sw15_reset),
        .count(sw15_counter)
    );

    always @ (*) begin
        sw15_reset <= !sw[15];
    end

    always @ (*) begin
        if (!is_done_init) begin
            led[15] <= 0;
            led[9:0] <= {10 {1'b1}} >> (10 - init_counter);
            seg <= constants.SEG_BLANK;
            an <= 4'b1111;
        end

        else if (is_done_init && !is_unlocked) begin
            led[15] <= 0;
            led[9:3] <= {7 {1'b1}};
            led[2] <= sw[2] ? clk_100_Hz : 1;
            led[1] <= (!sw[2] && sw[1]) ? clk_10_Hz : 1;
            led[0] <= (!sw[2] && !sw[1] && sw[0]) ? clk_1_Hz : 1;


            case (button_state)
                0 : {seg, an} <= {constants.SEG_btnD, 4'b1110};
                1 : {seg, an} <= {constants.SEG_btnL, 4'b1101};
                2 : {seg, an} <= {constants.SEG_btnR, 4'b1011};
            endcase           
        end

        else if (is_done_init && is_unlocked) begin
            led[15] <= 1;
            if (sw15_counter >= 300_000_000) begin
                led <= 16'b1000_0001_1010_0010;
                {seg, an} <= {constants.SEG_LETTER_W, 4'b0000};


            end
            else begin
                led[9:3] <= {7 {1'b1}};
                led[2] <= sw[2] ? clk_100_Hz : 1;
                led[1] <= (!sw[2] && sw[1]) ? clk_10_Hz : 1;
                led[0] <= (!sw[2] && !sw[1] && sw[0]) ? clk_1_Hz : 1;

                cycle_clk <= sw[2]
                    ? clk_200_Hz
                    : (sw[1]
                        ? clk_20_Hz
                        : (sw[0] 
                            ? clk_2_Hz
                            : 0));
                            
                case (cycle_counter)
                    0 : {seg, an} <= {constants.SEG_btnD, 4'b1110};
                    1 : {seg, an} <= {constants.SEG_btnL, 4'b1101};
                    2 : {seg, an} <= {constants.SEG_btnR, 4'b1011};
                endcase
            end
        end
    end

endmodule
