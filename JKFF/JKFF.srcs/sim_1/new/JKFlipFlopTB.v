`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2026 13:10:52
// Design Name: 
// Module Name: JKFlipFlopTB
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


module JKFlipFlopTB;
    reg Clk;
    reg J;
    reg K;
    reg Rst;
    wire Q;
    // Instantiate Unit Under Test (UUT)
    JKFlipFlop uut (
        .Clk(Clk),
        .J(J),
        .K(K),
        .Rst(Rst),
        .Q(Q)
    );
    
    initial Clk = 1'b0;
    always #5 Clk = ~Clk;
    
    initial begin
        $monitor("Time = %0t ns | Clk = %b, J = %b, K = %b, Rst = %b | Q = %b", 
                 $time, Clk, J, K, Rst, Q);
        Rst = 1'b1; J = 1'b0; K = 1'b0; #12;   // reset held
        Rst = 1'b0; J = 1'b1; K = 1'b0; #10;   // Set -> Q should become 1
        J = 1'b0; K = 1'b0; #10;               // Hold -> Q should stay 1
        J = 1'b0; K = 1'b1; #10;               // Reset -> Q should become 0
        J = 1'b1; K = 1'b1; #20;               // Toggle -> Q should flip every posedge
        $finish;
    end
endmodule 
