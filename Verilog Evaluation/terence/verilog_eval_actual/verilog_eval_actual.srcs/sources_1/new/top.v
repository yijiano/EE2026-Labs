
module top(
    input clk,
    input btnC, btnU, btnL, btnR, btnD, 
    input [15:0] sw,
    output [15:0] led, output reg dp, output reg [6:0] seg, output reg [3:0] an
    ); 
    
    /* --- Clocks ------------------------------------------------------------*/    
    //wire clk_1hz;
    wire clk_2hz;
    //clk_counter #(50_000_000, 50_000_000, 30) clk_1hz_module  (clk, clk_1hz);
    clk_counter #(25_000_000, 25_000_000, 30) clk_2hz_module  (clk, clk_2hz);
    
    /* --- FSM Code -------------------------------------------*/
    wire a_dp;
    wire [6:0] a_seg;
    wire [3:0] a_an;
    
    reg unlock_b = 0;
    wire unlock_c_2; // reg unlock_c_2 = 0;
    reg [2:0] state_c_2 = 0;
    
    /* --- 7 segment display configuration ------------------------------------*/
    // 7 segment display configuration
    always @ (*) begin
        /* Subtask A -------------------------------------*/
        if (~unlock_c_2) begin // Start State
            an <= a_an;
            seg <= a_seg;
            dp = a_dp;
        /* Subtask C -------------------------------------*/
        end else if (state_c_2 == 0) begin
            an <= 4'b0111;
            seg <= 7'b0100001; // d
            dp <= 0;
        end else if (state_c_2 == 1) begin
            an <= 4'b1011;
            seg <= 7'b1000000; // 0
            dp <= 1;          
        end else if (state_c_2 == 2) begin
            an <= 4'b1101;
            seg <= 7'b0101011; // n
            dp <= 1;          
        end else if (state_c_2 == 3) begin
            an <= 4'b1110;
            seg <= 7'b0000110; // E
            dp <= 1;         
        /* Debugging -------------------------------------*/
        end else begin
            seg = 7'b0000000; // l
            dp = 'b1;
            an = 4'b1110;
        end
    end
    
    /* --- Button Code -------------------------------------------*/
    reg prev_btnC=0, prev_btnU=0, prev_btnL=0, prev_btnR=0, prev_btnD=0;
    always @ (posedge clk) begin
        if (prev_btnC == 1 && btnC == 0) begin // release
            unlock_b <= 1;
        end
        
        prev_btnC <= btnC; prev_btnU <= btnU; prev_btnL <= btnL; 
        prev_btnR <= btnR; prev_btnD <= btnD;
    end
    
    /* --- Subtasks --------------------------------------------------------------------------------------*/
    /* --- Subtask A -------------------------------------------*/
    wire an3_on = sw[14] & sw[15];
    wire an0_on = sw[0] & sw[1];
    parameter CHAR = 7'b0110110;
    seg_multiplexer s(clk, 
        an0_on ? CHAR : ~7'b0, ~7'b0, ~7'b0, an3_on ? CHAR : ~7'b0,
        ~an0_on, 1, 1, ~an3_on, 
        a_seg, a_dp, a_an
    );
    /* --- Subtask B -------------------------------------------*/
    parameter SPEED_CHANGE_VAL = 9'b111;
    reg [9:0] trigger_b=9'b1;
    reg [30:0] counter_b=0; // Tested & measured, should be correct
    always @ (posedge clk) begin
        if (unlock_b) begin
            counter_b <= counter_b + 1;
            if (trigger_b < SPEED_CHANGE_VAL && counter_b == 100_000_000) begin // Y seconds
                trigger_b <= ((trigger_b << 1) | 11'b1); // don't need to switch
                counter_b <= 0;
            end else if (trigger_b >= SPEED_CHANGE_VAL && counter_b == 50_000_000) begin // Z seconds
                trigger_b <= ((trigger_b << 1) | 11'b1); // don't need to switch
                counter_b <= 0;
            end
        end
    end
    assign led[11:3] = unlock_b ? trigger_b : 11'b0;
    assign led[13] = unlock_b ? trigger_b[6] : 1'b0;
    assign led[12] = unlock_b ? trigger_b[7] : 1'b0;
    
    /* --- Subtask C -------------------------------------------*/
    // Part 1
    assign led[0] = btnU & clk_2hz;
    assign led[1] = btnU & clk_2hz;
    assign led[2] = btnU & clk_2hz;
    assign led[14] = btnU & clk_2hz;
    assign led[15] = btnU & clk_2hz;
    
    // Part 2
    trigger_counter #(400_000_000, 64, 1) trig_cnt(clk, btnR & btnL ,unlock_c_2);
    
    reg [32:0] counter_c = 0;
    always @ (posedge clk) begin
        if (unlock_c_2) begin
            counter_c <= counter_c + 1;
            if (counter_c == (175_000_000-1)) begin // include 0 state
                counter_c <= 0;
                state_c_2 <= state_c_2 == 3 ? 0 : state_c_2 + 1;
            end
        end else begin
            counter_c <= 0;
        end
    end
endmodule