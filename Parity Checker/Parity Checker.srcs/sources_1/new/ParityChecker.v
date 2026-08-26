`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 15:57:52
// Design Name: 
// Module Name: ParityChecker
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

module ParityChecker(
    input wire [3:0] Data,
    input wire ParityBit,
    output wire Error
    );
    
    assign Error = ^{Data, ParityBit}; //XOR from left to right after concantenation of the Data and ParityBit
endmodule