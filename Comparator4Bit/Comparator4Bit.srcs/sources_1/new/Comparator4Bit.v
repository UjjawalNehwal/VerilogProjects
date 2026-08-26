`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 15:25:17
// Design Name: 
// Module Name: Comparator4Bit
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


module Comparator4Bit(
    input wire [3:0] A, 
    input wire [3:0] B,
    output wire GT, 
    output wire EQ,
    output wire LT
    );
    
    assign GT = (A>B);
    assign EQ = (A==B);
    assign LT = (A<B);
    
endmodule
