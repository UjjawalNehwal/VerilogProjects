`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2026 13:06:51
// Design Name: 
// Module Name: JKFlipFlop
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


module JKFlipFlop(
    input wire Clk,
    input wire J,
    input wire K,
    input wire Rst,
    output reg Q
    );
    
    
    initial Q = 1'b0;
    always @(posedge Clk) begin
        if (Rst)
            Q <= 1'b0;
        else begin
            case ({J, K})
                2'b00: Q <= Q;
                2'b01: Q <= 1'b0;
                2'b10: Q <= 1'b1;
                2'b11: Q <= ~Q;
            endcase
        end
    end
    
endmodule
