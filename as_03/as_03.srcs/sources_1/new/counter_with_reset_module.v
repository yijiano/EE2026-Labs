`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2024 06:13:26
// Design Name: 
// Module Name: counter_with_reset_module
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


module counter_with_reset_module(
    input clk,
    input [31:0] max,
    input reset,
    output reg [31:0] count = 0
    );
    
    always @ (posedge clk) begin
        count = reset ? 0
                      : ((count >= max) ? max : count + 1);
    end
endmodule
