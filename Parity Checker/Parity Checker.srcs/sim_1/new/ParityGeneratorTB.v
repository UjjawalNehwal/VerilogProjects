`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 16:03:56
// Design Name: 
// Module Name: ParityGeneratorTB
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


module ParityGeneratorTB;
    reg [3:0] Data;
    wire ParityBit;
    
    ParityGenerator uut (
        .Data(Data),
        .ParityBit(ParityBit)
    );
    initial begin
        $monitor("Time = %0t ns | Inputs: Data = %b | Output: ParityBit = %b", $time, Data, ParityBit);
        Data = 4'b0000; #10;   // zero 1s (even) -> ParityBit = 0
        Data = 4'b0001; #10;   // one 1 (odd) -> ParityBit = 1
        Data = 4'b0011; #10;   // two 1s (even) -> ParityBit = 0
        Data = 4'b0111; #10;   // three 1s (odd) -> ParityBit = 1
        Data = 4'b1111; #10;   // four 1s (even) -> ParityBit = 0
        Data = 4'b1010; #10;   // two 1s (even) -> ParityBit = 0
        Data = 4'b1101; #10;   // three 1s (odd) -> ParityBit = 1
        $finish;
    end
endmodule
