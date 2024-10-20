`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2024 14:20:56
// Design Name: 
// Module Name: test_clock
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


module test_clock();
    reg CLOCK; reg LED;

    Top_Student dut(CLOCK, OUT);

    initial begin
        CLOCK = 0;
    end

    always begin
        #5 CLOCK = ~CLOCK;
    end
endmodule
