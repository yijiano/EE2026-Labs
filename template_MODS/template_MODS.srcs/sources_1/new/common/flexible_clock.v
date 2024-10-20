`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2024 14:12:45
// Design Name: 
// Module Name: flexible_clock
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


module flexible_clock(input basys_clock, [31:0] m, output reg clk_out = 0);
        
        reg [31:0] count = 0; 
        always @ (posedge basys_clock) begin
        
        count <= (count >= m) ? 0 : count + 1; 
        clk_out <= (count == 0) ? ~clk_out : clk_out; 
        end
                
endmodule
