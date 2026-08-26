`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 15:57:52
// Design Name: 
// Module Name: ParityGenerator
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


module ParityGenerator(
    input wire [3:0] Data,
    output wire ParityBit
    );
    
    assign ParityBit = ^Data;  //Self XOR of the bits from left to right
    
endmodule
