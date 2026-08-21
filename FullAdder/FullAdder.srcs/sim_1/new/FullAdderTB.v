`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2026 06:21:50
// Design Name: 
// Module Name: FullAdderTB
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


module FullAdderTB;
    reg A;
    reg B;
    reg Cin;
    wire Sum;
    wire Cout;
   
    FullAdder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );
    initial begin
        $monitor("Time = %0t ns | Inputs: A = %b, B = %b, Cin = %b | Outputs: Cout = %b, Sum = %b", 
                 $time, A, B, Cin, Cout, Sum);
        // All 8 input combinations
        A = 1'b0; B = 1'b0; Cin = 1'b0; #10;
        A = 1'b0; B = 1'b0; Cin = 1'b1; #10;
        A = 1'b0; B = 1'b1; Cin = 1'b0; #10;
        A = 1'b0; B = 1'b1; Cin = 1'b1; #10;
        A = 1'b1; B = 1'b0; Cin = 1'b0; #10;
        A = 1'b1; B = 1'b0; Cin = 1'b1; #10;
        A = 1'b1; B = 1'b1; Cin = 1'b0; #10;
        A = 1'b1; B = 1'b1; Cin = 1'b1; #10;
        $finish;
    end
endmodule
