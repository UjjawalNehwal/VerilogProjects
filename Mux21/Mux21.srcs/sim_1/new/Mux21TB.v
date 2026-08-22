`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 01:53:24
// Design Name: 
// Module Name: Mux21TB
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


module Mux21TB( );
    reg A;
    reg B;
    reg Sel;
    wire Y;
    Mux21 uut  ( 
        .A(A),
        .B(B),
        .Sel(Sel),
        .Y(Y)
        
    );
    
    initial begin
        $monitor ("Time = %0t ns | Inputs: A = %b, B = %b, Sel = %b | Outputs: Y = %b", $time, A, B, Sel, Y);
        
        A = 1'b0; B = 1'b0; Sel = 1'b0; #10;
        A = 1'b0; B = 1'b0; Sel = 1'b1; #10;
        A = 1'b0; B = 1'b1; Sel = 1'b0; #10;
        A = 1'b0; B = 1'b1; Sel = 1'b1; #10;
        A = 1'b1; B = 1'b0; Sel = 1'b0; #10;
        A = 1'b1; B = 1'b0; Sel = 1'b1; #10;
        A = 1'b1; B = 1'b1; Sel = 1'b0; #10;
        A = 1'b1; B = 1'b1; Sel = 1'b1; #10;
        $finish;
    end
endmodule
