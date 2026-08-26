`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 16:18:49
// Design Name: 
// Module Name: Gray2Binary
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


module Gray2Binary(    
    input wire [3:0] Gray,
    output wire [3:0] Bin
    );
    
    assign Bin [3] = Gray[3];
    assign Bin [2] = Gray[2] ^ Gray [3];
    assign Bin [1] = Gray[1] ^ Gray [2];
    assign Bin [0] = Gray[0] ^ Gray [1];
endmodule
