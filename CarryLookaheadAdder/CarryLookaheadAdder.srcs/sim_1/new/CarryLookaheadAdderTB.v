`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 13:25:06
// Design Name: 
// Module Name: CarryLookaheadAdderTB
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


module CarryLookaheadAdderTB();
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] Sum;
    wire Cout;
    
    CarryLookaheadAdder uut (
        .A(A),
        .B(B),
        .Sum(Sum),
        .Cin(Cin),
        .Cout(Cout)
    );
    
    initial begin
        $monitor("Time = %0t ns | Inputs: A = %b, B = %b, Cin = %b | Outputs: Cout = %b, Sum = %b", $time, A, B, Cin, Cout, Sum);
        A = 4'b0000; B = 4'b0000; Cin = 1'b0; #10;
        A = 4'b0001; B = 4'b0001; Cin = 1'b0; #10;
        A = 4'b0011; B = 4'b0101; Cin = 1'b0; #10;
        A = 4'b0001; B = 4'b0001; Cin = 1'b1; #10;
        A = 4'b1111; B = 4'b0001; Cin = 1'b0; #10;
        A = 4'b1111; B = 4'b1111; Cin = 1'b1; #10;
        A = 4'b1110; B = 4'b0001; Cin = 1'b0; #10;
        $finish;
    end
                 
endmodule
