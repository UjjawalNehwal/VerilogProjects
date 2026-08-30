`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 10:16:26
// Design Name: 
// Module Name: AsyncDFF
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


module AsyncDFF(
    input wire Clk,
    input wire D,
    input wire Rst,
    output reg Q
    );
    
    always @(posedge Clk or posedge Rst) begin
        if (Rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
    
endmodule
