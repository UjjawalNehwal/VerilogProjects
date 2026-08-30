`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2026 05:55:32
// Design Name: 
// Module Name: BarrelShifterTB
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


module BarrelShifterTB;
    reg [7:0] Data;
    reg [2:0] ShiftAmt;
    reg Direction;
    reg Mode;
    wire [7:0] Result;
    // Instantiate Unit Under Test (UUT)
    BarrelShifter uut (
        .Data(Data),
        .ShiftAmt(ShiftAmt),
        .Direction(Direction),
        .Mode(Mode),
        .Result(Result)
    );
    initial begin
        $monitor("Time = %0t ns | Inputs: Data = %b, ShiftAmt = %b, Direction = %b, Mode = %b | Output: Result = %b", 
                 $time, Data, ShiftAmt, Direction, Mode, Result);
        // Left shift, logical
        Data = 8'b00000101; ShiftAmt = 3'b010; Direction = 1'b0; Mode = 1'b0; #10;   // 5 << 2 = 20
        // Left shift, arithmetic (should behave same as logical left)
        Data = 8'b00000101; ShiftAmt = 3'b010; Direction = 1'b0; Mode = 1'b1; #10;
        // Right shift, logical, positive-looking data
        Data = 8'b00010000; ShiftAmt = 3'b010; Direction = 1'b1; Mode = 1'b0; #10;   // 16 >> 2 = 4
        // Right shift, logical, negative-looking data (MSB=1) -> fills with 0
        Data = 8'b11110000; ShiftAmt = 3'b010; Direction = 1'b1; Mode = 1'b0; #10;   // -> 00111100
        // Right shift, arithmetic, negative-looking data (MSB=1) -> fills with 1 (sign-extends)
        Data = 8'b11110000; ShiftAmt = 3'b010; Direction = 1'b1; Mode = 1'b1; #10;   // -> 11111100
        $finish;
    end
endmodule
