`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 16:18:49
// Design Name: 
// Module Name: Binary2Gray
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


module Binary2Gray(
    input wire [3:0] Bin,
    output wire [3:0] Gray
    );
    
    assign Gray [3] = Bin[3];
    assign Gray [2] = Bin[3] ^ Bin [2];
    assign Gray [1] = Bin[2] ^ Bin [1];
    assign Gray [0] = Bin[1] ^ Bin [0];
    
endmodule
