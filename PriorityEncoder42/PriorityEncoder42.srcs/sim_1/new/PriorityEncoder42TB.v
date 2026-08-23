`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 14:32:20
// Design Name: 
// Module Name: PriorityEncoder42TB
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


module PriorityEncoder42TB();
    reg [3:0]I;
    wire [1:0]Y;
    reg Valid;
    
    PriorityEncoder42 uut (
        .I(I),
        .Y(Y),
        .Valid(Valid)
    );
    
    initial begin
        $monitor("Time = %0t ns | Inputs: I = %b, Valid = %b | Output: Y = %b", $time, I, Valid ,Y);
        // Valid = 0: I should be ignored, Y should stay 00
        Valid = 1'b0; I = 4'b1111; #10;
        Valid = 1'b0; I = 4'b0000; #10;
        // Valid = 1: normal priority behavior, all 16 combinations
        Valid = 1'b1; I = 4'b0000; #10;
        Valid = 1'b1; I = 4'b0001; #10;
        Valid = 1'b1; I = 4'b0010; #10;
        Valid = 1'b1; I = 4'b0011; #10;
        Valid = 1'b1; I = 4'b0100; #10;
        Valid = 1'b1; I = 4'b0101; #10;
        Valid = 1'b1; I = 4'b0110; #10;
        Valid = 1'b1; I = 4'b0111; #10;
        Valid = 1'b1; I = 4'b1000; #10;
        Valid = 1'b1; I = 4'b1001; #10;
        Valid = 1'b1; I = 4'b1010; #10;
        Valid = 1'b1; I = 4'b1011; #10;
        Valid = 1'b1; I = 4'b1100; #10;
        Valid = 1'b1; I = 4'b1101; #10;
        Valid = 1'b1; I = 4'b1110; #10;
        Valid = 1'b1; I = 4'b1111; #10;
        $finish;
    end
endmodule
