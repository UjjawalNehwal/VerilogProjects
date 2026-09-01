`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 21:59:23
// Design Name: 
// Module Name: TFFTB
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


module TFlipFlopTB;
    reg Clk;
    reg T;
    reg Rst;
    wire Q;
    // Instantiate Unit Under Test (UUT)
    TFlipFlop uut (
        .Clk(Clk),
        .T(T),
        .Rst(Rst),
        .Q(Q)
    );
    
    initial Clk = 1'b0;
    always #5 Clk = ~Clk;
    
    initial begin
        $monitor("Time = %0t ns | Clk = %b, T = %b, Rst = %b | Q = %b", 
                 $time, Clk, T, Rst, Q);
        Rst = 1'b1; T = 1'b0; #12;    // reset held through at least one clock edge
        Rst = 1'b0; T = 1'b0; #10;    // T=0 -> Q should hold at 0
        T = 1'b1; #20;                // T=1 -> Q should toggle every posedge
        T = 1'b0; #10;                // T=0 -> Q should hold at whatever it last was
        $finish;
    end
endmodule
