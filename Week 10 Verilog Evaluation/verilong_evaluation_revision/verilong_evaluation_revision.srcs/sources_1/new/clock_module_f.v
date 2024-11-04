`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2024 16:07:32
// Design Name: 
// Module Name: clock_module
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


module clock_module_f(
    input clk,
    input [31:0] f,
    output reg out = 0
    );
    
    // Optimize bit width based on maximum count needed
    localparam BASYS_CLK = 100_000_000;  // Use localparam for constants
    
    // Calculate required counter bits based on maximum possible m value
    localparam COUNT_BITS = $clog2(BASYS_CLK/2);  
    
    // Optimize m calculation to use fewer bits
    wire [COUNT_BITS-1:0] m;
    assign m = (BASYS_CLK / (2 * f)) - 1;
    
    reg [COUNT_BITS-1:0] count = 0;
    
    always @(posedge clk) begin
        if(count >= m) begin
            count <= 0;
            out <= ~out;
        end
        else count <= count + 1;
    end
    
endmodule