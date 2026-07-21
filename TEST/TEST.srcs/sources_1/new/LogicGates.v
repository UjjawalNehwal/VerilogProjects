`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2026 23:31:54
// Design Name: 
// Module Name: LogicGates
// Project Name: PractisingVLSI
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


module LogicGates(
    input a,b,
    output x,y,z
    );
    assign x = ~a;
    assign y = a&b;
    assign z = a|b;
endmodule
