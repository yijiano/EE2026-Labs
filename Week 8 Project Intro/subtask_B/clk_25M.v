`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2024 16:27:00
// Design Name: 
// Module Name: clk_25M
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


module clk_25M(
    input basys_clock,
    output my_25mhz_clock
    );
    
   
    wire clk_25mhz;

    flexible_clock clock_divider (
        .basys_clock(basys_clock),
        .my_m_value(2),  // Setting my_m_value to 8 for 6.25 MHz output
        .my_clk(clk_25mhz)
    );

    assign my_25mhz_clock = clk_25mhz;
    
endmodule
