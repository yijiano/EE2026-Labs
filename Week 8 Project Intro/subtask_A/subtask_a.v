`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 00:55:57
// Design Name: 
// Module Name: subtask_A_module
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

module subtask_A_module (input btnU, btnC, reset, input basys_clock, output [7:0] JC);


wire c6p26 ,c1000, c25, fb, sending_pix, sample_pix;
reg toggle = 0;
reg [15:0] oled_data = 0;
wire [12:0] pix_index;
wire [6:0] x;
wire [6:0] y;
wire btnU_stable;
wire btnC_stable;
assign x = pix_index % 96;
assign y = pix_index / 96;

reg outercircle = 0;
reg circle = 0;
reg square = 0;
reg greencircle = 0;
reg orangecircle = 0;
reg redcircle = 0;
reg greensquare = 0;
reg orangesquare = 0;
reg redsquare = 0;

reg [31:0] counter = 0;

reg [4:0] state = 1;

debounce btnU_debounce (.clk(c6p26),.button(btnU),.debounced_button(btnU_stable));
debounce btnC_debounce (.clk(c6p26),.button(btnC),.debounced_button(btnC_stable));

reg btnU_stable_last = 0;
wire btnU_pressed = (btnU_stable && !btnU_stable_last);

reg btnC_stable_last = 0;
wire btnC_pressed = (btnC_stable && !btnC_stable_last);

reg btnU_released = 1;
reg btnC_released = 1;

always @ (posedge c25) begin
    // Store previous stable states for both buttons
    btnU_stable_last <= btnU_stable;
    btnC_stable_last <= btnC_stable;
    
    // Outer circle frame
    if ((((x >= 89 && x <= 91) || (x >= 4 && x <= 6)) && y >= 4 && y <= 59) ||
         ((x >= 4 && x <= 91) && ((y >= 4 && y <= 6) || (y >= 57 && y <= 59)))  )
        oled_data <= 16'b11111_000000_00000;
    // Outer circle drawing
    else if (((x-48) * (x-48) + (y-32) * (y-32) >= 324) && ((x-48) * (x-48) + (y-32) * (y-32) <= 441) && outercircle)
        oled_data <= circle ? 16'b11111_101000_00000 : square ? 16'b11111_111111_11111 : 16'b11111_101000_00000;
    // Circle and square rendering based on the current state
    else if ( (x-48) * (x-48) + (y-32) * (y-32) <= 100 && circle) begin
        oled_data <= greencircle ? 16'b00000_111111_00000 :
        orangecircle ? 16'b11111_101000_00000 : 
        redcircle ? 16'b11111_000000_00000 : 16'b10101_101010_10101;
    end
    else if ( (x >= 40 && x <= 55 && y >= 25 && y <= 40) && square) begin
        oled_data <= greensquare ? 16'b00000_111111_00000 :
        orangesquare ? 16'b11111_101000_00000 : 
        redsquare ? 16'b11111_000000_00000 : 16'b10101_101010_10101;
    end
    else 
        oled_data <= 16'b00000_000000_00000;
        
    // Reset logic
    if (reset == 1) begin
        circle <= 0;
        square <= 0;
        outercircle <= 0;
        state <= 1;
    end
    
    // Handling button U (Outer circle drawing)
    if (btnU_stable && btnU_released) begin
        btnU_released <= 0; // Button is pressed, so no longer released
        if (state == 1) begin
            outercircle <= 1;
            state <= state + 1;
        end
    end else if (!btnU_stable) begin
        btnU_released <= 1; // Button has been released, ready for the next press
    end
    
    // Handling button C (State transitions)
    if (btnC_stable && btnC_released) begin
        btnC_released <= 0; // Button is pressed, no longer released
        // Transition through different states
        if (state == 2) begin
            circle <= 1;
            square <= 0;
            greencircle <= 1;
            orangecircle <= 0;
            redcircle <= 0;
            state <= state + 1;
        end
        else if (state == 3) begin
            greencircle <= 0;
            orangecircle <= 1;
            redcircle <= 0;
            state <= state + 1;
        end 
        else if (state == 4) begin
            greencircle <= 0;
            orangecircle <= 0;
            redcircle <= 1;
            state <= state + 1;
        end 
        else if (state == 5) begin
            square <= 1;
            circle <= 0;
            greensquare <= 1;
            orangesquare <= 0;
            redsquare <= 0;
            state <= state + 1;
        end
        else if (state == 6) begin
            greensquare <= 0;
            orangesquare <= 1;
            redsquare <= 0;
            state <= state + 1;
        end 
        else if (state == 7) begin
            greensquare <= 0;
            orangesquare <= 0;
            redsquare <= 1;
            state <= 2;
        end
    end else if (!btnC_stable) begin
        btnC_released <= 1; // Button has been released
    end
end

flexible_clock clock_6p26mhz (.m(7),.basys_clock(basys_clock), .clk_out(c6p26));
flexible_clock clock_25mhz (.m(1),.basys_clock(basys_clock), .clk_out(c25));


Oled_Display oled(.clk(c6p26), .reset(0), .frame_begin(fb), .sending_pixels(sending_pix),
  .sample_pixel(sample_pix), .pixel_index(pix_index), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]),
  .pmoden(JC[7]));

endmodule