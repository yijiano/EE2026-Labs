`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2024 14:10:51
// Design Name: 
// Module Name: test_blinky
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


module test_blinky();

    reg CLOCK; wire LED;

    slow_blinky_module dut (CLOCK, LED);

    initial begin
        CLOCK = 0;
    end

    always begin
        #5 CLOCK = ~CLOCK;
    end

endmodule
