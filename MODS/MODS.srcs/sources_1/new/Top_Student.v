`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: HOE ZHAN HAO
//  STUDENT B NAME: BRIAN CHAN SHI YUAN
//  STUDENT C NAME: CAI JIALI
//  STUDENT D NAME: ZHANG YIJIAN
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input clk,
                    input [4:0] btn,
                    input [15:0] sw,
                    output reg [15:0] led,
                    output [7:0] seg,
                    output [3:0] an,
                    output reg [7:0] JB);
        
    assign seg = 8'b1111_1111;
    assign an = 4'b1111;
    reg pause;

    wire [7:0] J_default, J_A, J_B, J_C, J_D;
    reg [4:0] btn_A, btn_B, btn_C, btn_D;

    parameter subtask_A_frequency = 5 + 1;
    parameter subtask_B_frequency = 9 + 1;
    parameter subtask_C_frequency = 3 + 1;
    parameter subtask_D_frequency = 5 + 1;

    wire subtask_A_clk;
    clock_module subtask_A_clk_module(    .clk(clk),
                                    .f_out(subtask_A_frequency),
                                    .out(subtask_A_clk));

    wire subtask_B_clk;
    clock_module subtask_B_clk_module(    .clk(clk),
                                    .f_out(subtask_B_frequency),
                                    .out(subtask_B_clk));

    wire subtask_C_clk;
    clock_module subtask_C_clk_module(    .clk(clk),
                                    .f_out(subtask_C_frequency),
                                    .out(subtask_C_clk));

    wire subtask_D_clk;
    clock_module subtask_D_clk_module(    .clk(clk),
                                    .f_out(subtask_D_frequency),
                                    .out(subtask_D_clk));

    always @ (*)
    begin
        //subtask_A
        if (sw[15:0] == 16'b0001_00_00111_01111)
        begin
            pause <= 0;
            btn_A <= btn;
            btn_B <= 5'b00000;
            btn_C <= 5'b00000;
            btn_D <= 5'b00000;
            JB <= J_A;
            led[15:10] <= 6'b0001_00;
            led[9] <= 0;
            led[8] <= 0;
            led[7] <= subtask_A_clk;
            led[6] <= subtask_A_clk;
            led[5] <= subtask_A_clk;
            led[4] <= 0;
            led[3] <= subtask_A_clk;
            led[2] <= subtask_A_clk;
            led[1] <= subtask_A_clk;
            led[0] <= subtask_A_clk;
        end

        //subtask_B
        else if (sw[15:0] == 16'b0010_00_11000_00111)
        begin
            pause <= 0;
            btn_A <= 5'b00000;
            btn_B <= btn;
            btn_C <= 5'b00000;
            btn_D <= 5'b00000;
            JB <= J_B;
            led[15:10] <= 6'b0010_00;
            led[9] <= subtask_B_clk;
            led[8] <= subtask_B_clk;
            led[7] <= 0;
            led[6] <= 0;
            led[5] <= 0;
            led[4] <= 0;
            led[3] <= 0;
            led[2] <= subtask_B_clk;
            led[1] <= subtask_B_clk;
            led[0] <= subtask_B_clk;
        end

        //subtask_C
        else if (sw[15:0] == 16'b0100_00_01001_01101)
        begin
            pause <= 0;
            btn_A <= 5'b00000;
            btn_B <= 5'b00000;
            btn_C <= btn;
            btn_D <= 5'b00000;
            JB <= J_C;
            led[15:10] <= 6'b0100_00;
            led[9] <= 0;
            led[8] <= subtask_C_clk;
            led[7] <= 0;
            led[6] <= 0;
            led[5] <= subtask_C_clk;
            led[4] <= 0;
            led[3] <= subtask_C_clk;
            led[2] <= subtask_C_clk;
            led[1] <= 0;
            led[0] <= subtask_C_clk;
        end

        //subtask_D
        else if (sw[15:0] == 16'b1000_00_01101_00111)
        begin
            pause <= 0;
            btn_A <= 5'b00000;
            btn_B <= 5'b00000;
            btn_C <= 5'b00000;
            btn_D <= btn;
            JB <= J_D;
            led[15:10] <= 6'b1000_00;
            led[9] <= 0;
            led[8] <= subtask_D_clk;
            led[7] <= subtask_D_clk;
            led[6] <= 0;
            led[5] <= subtask_D_clk;
            led[4] <= 0;
            led[3] <= 0;
            led[2] <= subtask_D_clk;
            led[1] <= subtask_D_clk;
            led[0] <= subtask_D_clk;
        end

        else
        begin
            pause <= 1;
            btn_A <= 5'b00000;
            btn_B <= 5'b00000;
            btn_C <= 5'b00000;
            btn_D <= 5'b00000;
            JB <= J_default;
            led[15:0] <= sw[15:0];
        end
    end
    
    //btn[0] = btnC
    //btn[1] = btnU
    //btn[2] = btnL
    //btn[3] = btnR
    //btn[4] = btnD

    default_screen_module default_screen(  .clk(clk),
                                    .JB(J_default));

    subtask_A_module subtask_A( .basys_clock(clk),
                                .btnU(btn_A[1]),
                                .btnC(btn_A[0]),
                                .reset(pause),
                                .JC(J_A));
    
    subtask_B_module subtask_B( .basys_clock(clk),
                                .btnU(btn_B[1]), 
                                .btnD(btn_B[4]),
                                .btnC(btn_B[0]),   
                                .reset(pause),    
                                .JB(J_B));

    subtask_C_module subtask_C( .clk(clk),
                                .btnC(btn_C[0]),
                                .btnU(btn_C[1]), 
                                .pause(pause),
                                .JC(J_C));
    
    subtask_D_module subtask_D( .clk(clk),
                                .btn(btn_D),
                                .pause(pause),
                                .JB(J_D));   
endmodule
