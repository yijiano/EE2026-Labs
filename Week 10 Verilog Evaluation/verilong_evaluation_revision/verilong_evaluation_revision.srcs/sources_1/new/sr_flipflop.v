`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2024 22:36:02
// Design Name: 
// Module Name: sr_flipflop
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


module debounce(
    input clk,                  // 6.25 MHz clock
    input button,               // Raw button input
    output reg debounced_button  // Debounced button output
);
    reg [20:0] counter = 0;     // Counter for debounce timing (200ms at 6.25 MHz)
    reg button_state = 0;       // Stores the current button state (stable state)
    reg button_pressed = 0;     // Tracks if the button press is being processed

    always @(posedge clk) begin
        // Check if the button is pressed and it's not already being processed
        if (button && !button_pressed) begin
            button_pressed <= 1;          // Mark button as being pressed
            counter <= 1250000;           // Start 200ms debounce counter (6.25 MHz * 0.2s)
            debounced_button <= 1;        // Register button press (state change)
        end else if (counter > 0) begin
            counter <= counter - 1;       // Continue counting down during debounce period
        end else if (button_pressed) begin
            if (!button) begin            // If button is released
                button_pressed <= 0;      // Reset press tracking when button is released
            end
            debounced_button <= 0;        // Set debounced output to 0 (reset)
        end
    end
endmodule

