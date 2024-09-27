`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.08.2024 15:18:43
// Design Name: 
// Module Name: password_sim
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


module password_sim(

    );
    
    // Siulation Inputs
    reg [9:0] sw;
    
    // Simulation Outputs
    wire [9:0] led;
    wire [3:0] an;
    wire [6:0] seg;
    wire dp;
    wire led_pass;
    
    // Instantisation of the module to be simulted
    password_module dut(sw[9:0], led[9:0], led_pass, an[3:0], seg[6:0], dp);
    
    // Stimuli
    initial begin
        sw[9:0] = 10'b010; #10;
        sw[9:0] = 10'b0; #10;
    end
    
endmodule
