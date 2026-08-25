`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 14:59:13
// Design Name: 
// Module Name: Decoder38TB
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


module Decoder38TB();
    reg [2:0] Sel;
    reg Enable;
    wire [7:0] Y;
    
    Decoder38 uut (
        .Sel(Sel),
        .Enable(Enable),
        .Y(Y)
    );
    
    initial begin 
        $monitor ("Time =%0t ns| Inputs : Sel = %b, Enable = %b | Outputs: Y = %b", $time, Sel, Enable, Y);
        
        // Enable = 0: Y should stay all-zero regardless of Sel
        Enable = 1'b0; Sel = 3'b000; #10;
        Enable = 1'b0; Sel = 3'b111; #10;
        // Enable = 1: normal decode behavior, all 8 combinations
        Enable = 1'b1; Sel = 3'b000; #10;
        Enable = 1'b1; Sel = 3'b001; #10;
        Enable = 1'b1; Sel = 3'b010; #10;
        Enable = 1'b1; Sel = 3'b011; #10;
        Enable = 1'b1; Sel = 3'b100; #10;
        Enable = 1'b1; Sel = 3'b101; #10;
        Enable = 1'b1; Sel = 3'b110; #10;
        Enable = 1'b1; Sel = 3'b111; #10;
        $finish;
    end
endmodule
