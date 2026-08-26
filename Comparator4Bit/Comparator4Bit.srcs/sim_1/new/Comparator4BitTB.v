`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 15:34:41
// Design Name: 
// Module Name: Comparator4BitTB
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


module Comparator4BitTB();
    reg [3:0] A;
    reg [3:0] B;
    wire GT;
    wire EQ;
    wire LT;
    
    Comparator4Bit uut (
        .A(A),
        .B(B),
        .GT(GT),
        .EQ(EQ),
        .LT(LT)
    );
    
    initial begin
        $monitor("Time = %0t ns | Inputs: A = %b, B = %b | Outputs: GT = %b, EQ = %b, LT = %b", $time, A, B, GT, EQ, LT);
        A = 4'b0101; B = 4'b0011; #10;   // A > B
        A = 4'b0011; B = 4'b0101; #10;   // A < B
        A = 4'b0110; B = 4'b0110; #10;   // A == B
        A = 4'b0000; B = 4'b1111; #10;   // extreme: A < B
        A = 4'b1111; B = 4'b0000; #10;   // extreme: A > B
        A = 4'b0000; B = 4'b0000; #10;   // extreme: A == B
        $finish;
    end
    
endmodule
