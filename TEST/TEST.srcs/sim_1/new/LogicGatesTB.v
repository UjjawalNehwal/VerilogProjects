`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2026 00:22:14
// Design Name: 
// Module Name: LogicGatesTB
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


module LogicGatesTB(
    );
    
reg a,b;
wire x,y,z;

LogicGates uut(a,b,x,y,z);

initial
begin
    a=0; b=0;
   #10  a=0; b=1;
   #10  a=1; b=0;
   #10  a=1; b=1;
   #10 $finish;
end
endmodule
