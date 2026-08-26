`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 16:03:56
// Design Name: 
// Module Name: ParityCheckerTB
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


module ParityCheckerTB;
    reg [3:0] Data;
    reg ParityBit;
    wire Error;
    
    ParityChecker uut (
        .Data(Data),
        .ParityBit(ParityBit),
        .Error(Error)
    );
    initial begin
        $monitor("Time = %0t ns | Inputs: Data = %b, ParityBit = %b | Output: Error = %b", $time, Data, ParityBit, Error);
        // Correct parity (matches generator's output) -> Error should be 0
        Data = 4'b0000; ParityBit = 1'b0; #10;
        Data = 4'b0001; ParityBit = 1'b1; #10;
        Data = 4'b1111; ParityBit = 1'b0; #10;
        // Deliberately WRONG parity (simulating corruption) -> Error should be 1
        Data = 4'b0000; ParityBit = 1'b1; #10;
        Data = 4'b0001; ParityBit = 1'b0; #10;
        Data = 4'b1111; ParityBit = 1'b1; #10;
        $finish;
    end
endmodule
