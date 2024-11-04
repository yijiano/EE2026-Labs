`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2024 15:01:27
// Design Name: 
// Module Name: switch_and_led_module
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


module password_module(
    input [9:0] sw,
    output [9:0] led,
    output led_pass,
    output [3:0] an,
    output [6:0] seg,
    output dp
    );
    
    // Correct password statem, password is 7, 1, 5, 8, 5 (duplicate 5)
    wire c = (sw[9:0] == 10'b0110100010);
    
    // Initialisation, display '5'; correct password, display 'W' (7'b1010101)    
    assign seg = c ? 7'b1010101 : 7'b0011010;
    assign dp = 1'b1;
    
    // Set common anode
    assign an[3:0] = {1'b1, 1'b0, c, 1'b0};
    
    // Individual Switches
    assign led[9:0] = sw[9:0];
    assign led_pass = c;
    
endmodule
