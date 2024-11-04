`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 05:57:00
// Design Name: 
// Module Name: button_handler_module
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


module button_handler_module(   input clk,
                                input [4:0] btn,
                                input pause,
                                output reg stop,
                                output reg [1:0] dir);

    wire clk_1kHz;
    clock_module clk_1kHz_module(  .clk(clk),
                                    .f_out(1_000),
                                    .out(clk_1kHz));

    // 2'b00: Up
    // 2'b01: Left
    // 2'b10: Right
    // 2'b11: Down
    // else stop
    always @ (posedge clk_1kHz)
    begin
        //btn[0] = btnC
        if (pause || btn[0])
            stop <= 1;

        //btn[1] = btnU
        else if (btn[1])
        begin
            stop <= 0; 
            dir <= 2'b00;
        end

        //btn[2] = btnL
        else if (btn[2])
        begin
            stop <= 0; 
            dir <= 2'b01;
        end    

        //btn[3] = btnR
        else if (btn[3])
        begin
            stop <= 0; 
            dir <= 2'b10;
        end           

        //btn[4] = btnD
        else if (btn[4])
        begin
            stop <= 0; 
            dir <= 2'b11;
        end
    end
endmodule
