
`timescale 1ns / 1ps

module oled_module_C(
    input [12:0] pixel_index, 
    input clk_625MHz, 
    btnC, 
    btnU, 
    pause, 
    output reg [15:0] oled_color = 16'b0000_0000_0000
);
    reg [1:0] state;
    reg start;
    reg [31:0] countWaitClk;
    reg [1:0] movementPhase;
    reg [31:0] countClk;
    reg signed [7:0] countPixel; 
    wire [6:0] x; 
    wire [5:0] y; 
    assign x = pixel_index % 96; 
    assign y = pixel_index / 96; 

    initial begin
        start = 0;
        state = 0; // 0 for 1st green state; 1 for red state; 2 for 2nd green state
        countPixel = 0;
        movementPhase = 0;
        countWaitClk = 0; 
        countClk = 0;
    end
    
    always @(posedge clk_625MHz) begin
        // Reset
        if (pause) begin
            start <= 0;
            state <= 0; 
            countPixel <= 0;
            movementPhase <= 0;
            countWaitClk <= 0; 
            countClk <= 0;
        end else begin // For resetting, add an else here
            case (state)
                0: begin // 1st green state
                    // Start phase
                    if (countPixel == 0) begin
                        if (x < 15 && y < 15) oled_color <= 16'b00000_111111_00000;
                        else oled_color <= 16'b00000_000000_00000;
                    end

                    // Moving phase
                    if (btnC && !start) begin
                        start <= 1;
                    end

                    if (start) begin 
                        if (countClk == 208_333) begin 
                            countClk <= 0;
                            if (movementPhase == 0 && countPixel < 81) countPixel <= countPixel + 1;
                            else if (movementPhase == 1 && countPixel < 49) countPixel <= countPixel + 1;
                            else if (movementPhase == 2 && countPixel < 81) countPixel <= countPixel + 1;
                        end else begin
                            countClk <= countClk + 1;
                        end
                        
                        case (movementPhase)
                            0: begin
                                if (countPixel < 81) begin
                                    if (x <= (14 + countPixel) && y <= 14) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    if (countWaitClk < 12_500_000) begin 
                                        countWaitClk <= countWaitClk + 1; // Wait for 2 seconds
                                    end else begin
                                        movementPhase <= 1;
                                        countWaitClk <= 0;
                                        countPixel <= 1;
                                        countClk <= 0;
                                    end
                                    if (y <= 14) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end
                            end
                            1: begin
                                if (countPixel < 49) begin
                                    if (y <= 14 || (x >= 81 && y <= 14 + countPixel)) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    if (countWaitClk < 12_500_000) begin
                                        countWaitClk <= countWaitClk + 1; // Wait for 2 seconds
                                    end else begin
                                        countWaitClk <= 0;
                                        movementPhase <= 2;
                                        countPixel <= 1;
                                        countClk <= 0;
                                    end
                                    if (y <= 14 || x >= 81) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end
                            end
                            2: begin
                                if (countPixel < 81) begin
                                    if (y <= 14 || x >= 81 || (x >= 81 - countPixel && y >= 49)) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    if (countWaitClk < 12_500_000) begin
                                        countWaitClk <= countWaitClk + 1; // Wait for 2 seconds
                                    end else begin
                                        countClk <= 0;
                                        countWaitClk <= 0;
                                        start <= 0;
                                        countPixel <= 0;
                                        movementPhase <= 0;
                                        state <= 1;
                                    end
                                    if (y <= 14 || x >= 81 || y >= 49) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end
                            end
                        endcase
                    end
                end
                
                1: begin // Red state
                    // Start phase
                    if (countPixel == 0) begin
                        if (x <= 14 && y >= 49) oled_color <= 16'b11111_000000_00000;
                        else if ((y >= 49 && x > 14) || y <= 14 || x >= 81) oled_color <= 16'b00000_111111_00000;
                        else oled_color <= 16'b00000_000000_00000;
                    end

                    // Moving phase
                    if (btnU && !start) begin
                        start <= 1;
                        countPixel <= 0; // Reset countPixel for movement
                        countClk <= 0; // Reset countClk for accurate timing
                    end

                    if (start) begin
                        if (countClk == 125_000) begin // 0.3s to increase 15-pixel step
                            countClk <= 0;
                            countPixel <= countPixel + 1;
                        end else begin
                            countClk <= countClk + 1;
                        end
                        
                        case (movementPhase)
                            0: begin
                                if (countPixel < 81) begin
                                    if (x <= (14 + countPixel) && y >= 49) oled_color <= 16'b11111_000000_00000;
                                    else if ((y >= 49 && x > 14 + countPixel) || y <= 14 || x >= 81) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    countClk <= 0;
                                    movementPhase <= 1;
                                    countPixel <= 1;
                                end
                            end
                            1: begin
                                if (countPixel < 49) begin
                                    if ((x >= 81 && y >= 49 - countPixel) || y >= 49) oled_color <= 16'b11111_000000_00000;
                                    else if ((x >= 81 && y < 49 - countPixel) || y <= 14) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    countClk <= 0;
                                    movementPhase <= 2;
                                    countPixel <= 1;
                                end
                            end
                            2: begin
                                if (countPixel <= 81) begin
                                    if ((x >= 81 - countPixel && y <= 14) || x >= 81 || y >= 49) oled_color <= 16'b11111_000000_00000;
                                    else if (x < 81 - countPixel && y <= 14) oled_color <= 16'b00000_111111_00000;
                                    else oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    countClk <= 0;
                                    countPixel <= 0;
                                    movementPhase <= 0;
                                    state <= 2;
                                    start <= 0;
                                end
                            end
                        endcase
                    end
                end

                2: begin // 2nd green state
                    // Start phase
                    if (countPixel == 0) begin
                        if (x <= 14 && y <= 14) 
                            oled_color <= 16'b00000_111111_00000;
                        else if ((y <= 14 && x > 14) || y >= 49 || x >= 81) 
                            oled_color <= 16'b11111_000000_00000; 
                        else 
                            oled_color <= 16'b00000_000000_00000;
                    end
                
                    // Moving phase
                    if (btnC) start <= 1; // Start movement on button press
                
                    if (start) begin 
                        if (countClk == 208_333) begin // 0.5s to increase 15-pixel step
                            countClk <= 0; 
                            if (movementPhase == 0 && countPixel < 81) countPixel <= countPixel + 1;
                            else if (movementPhase == 1 && countPixel < 49) countPixel <= countPixel + 1;
                            else if (movementPhase == 2 && countPixel < 81) countPixel <= countPixel + 1;
                        end else begin
                            countClk <= countClk + 1; 
                        end
                        
                        case (movementPhase)
                            0: begin
                                if (countPixel < 81) begin
                                    if (x <= (14 + countPixel) && y <= 14) 
                                        oled_color <= 16'b00000_111111_00000;
                                    else if ((y <= 14 && x > 14 + countPixel) || x >= 81 || y >= 49) 
                                        oled_color <= 16'b11111_000000_00000; 
                                    else 
                                        oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    if (countWaitClk < 12_500_000) begin
                                        countWaitClk <= countWaitClk + 1; // Wait for 2 seconds
                                        if (y <= 14) oled_color <= 16'b00000_111111_00000;
                                        else if (x >= 81 || y >= 49) oled_color <= 16'b11111_000000_00000; 
                                        else oled_color <= 16'b00000_000000_00000;
                                    end else begin
                                        countClk <= 0;
                                        countWaitClk <= 0; 
                                        movementPhase <= 1; 
                                        countPixel <= 1;
                                    end
                                end
                            end
                            1: begin
                                if (countPixel < 49) begin
                                    if (y <= 14 || (x >= 81 && y <= 14 + countPixel)) 
                                        oled_color <= 16'b00000_111111_00000;
                                    else if ((x >= 81 && y > 14 + countPixel) || y >= 49) 
                                        oled_color <= 16'b11111_000000_00000;
                                    else 
                                        oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    if (countWaitClk < 12_500_000) begin
                                        countWaitClk <= countWaitClk + 1; // Wait for 2 seconds
                                        if (y <= 14 || x >= 81) 
                                            oled_color <= 16'b00000_111111_00000;
                                        else if (y >= 49) 
                                            oled_color <= 16'b11111_000000_00000;
                                        else 
                                            oled_color <= 16'b00000_000000_00000;
                                    end else begin
                                        countClk <= 0;
                                        countWaitClk <= 0; 
                                        movementPhase <= 2;
                                        countPixel <= 1; 
                                    end
                                end
                            end
                            2: begin
                                if (countPixel < 81) begin
                                    if (y <= 14 || x >= 81 || (x >= 81 - countPixel && y >= 49)) 
                                        oled_color <= 16'b00000_111111_00000; 
                                    else if (y >= 49 && x < 81 - countPixel) 
                                        oled_color <= 16'b11111_000000_00000;
                                    else 
                                        oled_color <= 16'b00000_000000_00000;
                                end else begin
                                    if (countWaitClk < 12_500_000) begin
                                        countWaitClk <= countWaitClk + 1; // Wait for 2 seconds
                                        if (y <= 14 || x >= 81 || y >= 49) 
                                            oled_color <= 16'b00000_111111_00000; 
                                        else 
                                            oled_color <= 16'b00000_000000_00000;
                                    end else begin
                                        countClk <= 0;
                                        countWaitClk <= 0; 
                                        start <= 0; 
                                        countPixel <= 0; 
                                        movementPhase <= 0;
                                        state <= 1; 
                                    end
                                end
                            end
                        endcase
                    end
                end
            endcase
        end
    end  
endmodule
