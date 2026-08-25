`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2026 15:37:02
// Design Name: 
// Module Name: RippleCarryAdderTB
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


module RippleCarryAdderTB();
    reg [3:0]A;
    reg [3:0]B;
    reg Cin;
    wire [3:0]Sum;
    wire Cout;
    
    RippleCarryAdder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );
    
    initial begin
        $monitor("Time = %0t ns | Inputs: A = %b, B = %b, Cin = %b | Outputs: Cout = %b, Sum = %b", 
                 $time, A, B, Cin, Cout, Sum);
        // Basic cases
        A = 4'b0000; B = 4'b0000; Cin = 1'b0; #10;   // 0 + 0 + 0 = 0
        A = 4'b0001; B = 4'b0001; Cin = 1'b0; #10;   // 1 + 1 = 2
        A = 4'b0011; B = 4'b0101; Cin = 1'b0; #10;   // 3 + 5 = 8
        // Carry-in test
        A = 4'b0001; B = 4'b0001; Cin = 1'b1; #10;   // 1 + 1 + 1 = 3
        // Full ripple: carry must propagate through all 4 stages
        A = 4'b1111; B = 4'b0001; Cin = 1'b0; #10;   // 15 + 1 = 16 -> Sum=0000, Cout=1
        // Max values
        A = 4'b1111; B = 4'b1111; Cin = 1'b1; #10;   // 15 + 15 + 1 = 31 -> Sum=1111, Cout=1
        // No overflow, near max
        A = 4'b1110; B = 4'b0001; Cin = 1'b0; #10;   // 14 + 1 = 15, no overflow
        $finish;
    end
endmodule
