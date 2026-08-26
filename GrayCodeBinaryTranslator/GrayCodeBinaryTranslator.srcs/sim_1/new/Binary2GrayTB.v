`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 17:02:54
// Design Name: 
// Module Name: Binary2GrayTB
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


module Binary2GrayTB;
    reg [3:0] Bin;
    wire [3:0] Gray;
    
    Binary2Gray uut (
        .Bin(Bin),
        .Gray(Gray)
    );
    initial begin
        $monitor("Time = %0t ns | Input: Bin = %b | Output: Gray = %b", $time, Bin, Gray);
        Bin = 4'b0000; #10;
        Bin = 4'b0001; #10;
        Bin = 4'b0010; #10;
        Bin = 4'b0011; #10;
        Bin = 4'b0100; #10;
        Bin = 4'b0101; #10;
        Bin = 4'b0110; #10;
        Bin = 4'b0111; #10;
        Bin = 4'b1000; #10;
        Bin = 4'b1001; #10;
        Bin = 4'b1010; #10;
        Bin = 4'b1011; #10;
        Bin = 4'b1100; #10;
        Bin = 4'b1101; #10;
        Bin = 4'b1110; #10;
        Bin = 4'b1111; #10;
        $finish;
    end
endmodule
