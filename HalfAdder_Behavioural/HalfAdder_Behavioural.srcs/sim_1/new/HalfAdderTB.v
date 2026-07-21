`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2026 04:27:52
// Design Name: 
// Module Name: HalfAdderTB
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


module HalfAdderTB;
    reg A;
    reg B;
    wire Sum;
    wire Carry;
    
    HalfAdder uut (
        .A(A),
        .B(B),
        .Sum(Sum),
        .Carry(Carry)
    );
    
    initial begin
        $monitor("Time = %0t ns | Inputs: A = %b, B = %b | Outputs: Carry = %b, Sum = %b", 
                 $time, A, B, Carry, Sum);
                 
                 A = 1'b0; B = 1'b0; #10;
                 A = 1'b0; B = 1'b1; #10;
                 A = 1'b1; B = 1'b0; #10;
                 A = 1'b1; B = 1'b1; #10;
                 
                 $finish;
    end              
endmodule




