`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 14:48:12
// Design Name: 
// Module Name: ParaALUTB
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


module AluTB;
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] OpSel;
    wire [3:0] Result;
    wire [3:0] ResultHigh;
    wire Carry;
    wire ZeroFlag;
    
    ParaALU uut(
        .A(A),
        .B(B),
        .OpSel(OpSel),
        .Result(Result),
        .ResultHigh(ResultHigh),
        .Carry(Carry),
        .ZeroFlag(ZeroFlag)
    );
    initial begin
        $monitor("Time = %0t ns | Inputs: A = %b, B = %b, OpSel = %b | Outputs: ResultHigh = %b, Result = %b, Carry = %b, ZeroFlag = %b", $time, A, B, OpSel, ResultHigh, Result, Carry, ZeroFlag);
        A = 4'b0011; B = 4'b0010; OpSel = 3'b000; #10;   // Add: 3+2=5
        A = 4'b0101; B = 4'b0010; OpSel = 3'b001; #10;   // Sub: 5-2=3
        A = 4'b1100; B = 4'b1010; OpSel = 3'b010; #10;   // AND
        A = 4'b1010; B = 4'b0101; OpSel = 3'b011; #10;   // OR
        A = 4'b1100; B = 4'b1010; OpSel = 3'b100; #10;   // XOR
        A = 4'b1100; B = 4'b1010; OpSel = 3'b101; #10;   // XNOR
        A = 4'b1010; B = 4'b0110; OpSel = 3'b110; #10;   // NOT: Result=~A, ResultHigh=~B
        A = 4'b1111; B = 4'b0001; OpSel = 3'b000; #10;   // Add overflow: 15+1=16
        A = 4'b0101; B = 4'b0101; OpSel = 3'b111; #10;   // Multiply: 5*5=25
        $finish;
    end
endmodule
