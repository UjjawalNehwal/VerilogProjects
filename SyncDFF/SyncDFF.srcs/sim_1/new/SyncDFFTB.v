`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2026 13:19:02
// Design Name: 
// Module Name: SyncDFFTB
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

module SyncDFFTB();
    reg Clk;
    reg D;
    reg Rst;
    wire Q;
    // Instantiate Unit Under Test (UUT)
    SyncDFF uut (
        .Clk(Clk),
        .D(D),
        .Rst(Rst),
        .Q(Q)
    );
    
    initial Clk = 1'b0;
    always #5 Clk = ~Clk;
    
    initial begin
        $monitor("Time = %0t ns | Clk = %b, D = %b, Rst = %b | Q = %b", 
                 $time, Clk, D, Rst, Q);
        Rst = 1'b1; D = 1'b0; #12;    // hold reset through at least one clock edge
        Rst = 1'b0; D = 1'b1; #10;    // release reset, D=1 -> Q should become 1 at next posedge
        D = 1'b0; #10;
        D = 1'b1; #10;
        Rst = 1'b1; #3;               // assert reset MID-cycle, between edges
        #10;                          // sync reset should NOT take effect until next posedge
        $finish;
    end
endmodule
