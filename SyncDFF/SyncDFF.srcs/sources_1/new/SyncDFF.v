`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 12:57:37
// Design Name: 
// Module Name: SyncDFF
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


module SyncDFF(
    input wire Clk,
    input wire D,
    input wire Rst,
    output reg Q
    );
    
     initial Q=1'b0;
    always @(posedge Clk) begin
        if (Rst)
            Q <= 1'b0;
        else
            Q <= D;
    end
    
endmodule
