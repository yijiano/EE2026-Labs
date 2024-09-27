`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12.09.2024 14:23:34
// Design Name:
// Module Name: slow_blinky_module
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


module slow_blinky_module(input CLOCK,
                          input [2:0] sw,
                          output reg LED = 0);
  reg [31:0] COUNT = 0;
  wire [31:0] m;
  
  assign m = sw[0] ? 2499999 : (sw[1] ? 9999999 : (sw[2] ? 49999999 : 0));
  always @ (posedge CLOCK)
  begin
    COUNT <= (COUNT >= m) ? 0 : COUNT + 1;
    LED <= (COUNT == 0) ? ~LED : LED;
  end

endmodule