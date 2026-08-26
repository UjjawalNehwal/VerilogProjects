`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 17:04:55
// Design Name: 
// Module Name: Gray2BinaryTB
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


module Gray2BinaryTB;
    reg [3:0] Gray;
    wire [3:0] Bin;
    
    Gray2Binary uut (
        .Gray(Gray),
        .Bin(Bin)
    );
    initial begin
        $monitor("Time = %0t ns | Input: Gray = %b | Output: Bin = %b", $time, Gray, Bin);
        Gray = 4'b0000; #10;
        Gray = 4'b0001; #10;
        Gray = 4'b0011; #10;
        Gray = 4'b0010; #10;
        Gray = 4'b0110; #10;
        Gray = 4'b0111; #10;
        Gray = 4'b0101; #10;
        Gray = 4'b0100; #10;
        Gray = 4'b1100; #10;
        Gray = 4'b1101; #10;
        Gray = 4'b1111; #10;
        Gray = 4'b1110; #10;
        Gray = 4'b1010; #10;
        Gray = 4'b1011; #10;
        Gray = 4'b1001; #10;
        Gray = 4'b1000; #10;
        $finish;
    end
endmodule
