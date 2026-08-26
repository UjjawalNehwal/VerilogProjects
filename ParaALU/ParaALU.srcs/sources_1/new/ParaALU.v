`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 14:30:33
// Design Name: 
// Module Name: ParaALU
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


module ParaALU 
    #( parameter Width=4)
    (
    input wire [Width-1:0] A,
    input wire [Width-1:0] B,
    input wire [2:0] OpSel,
    output reg [Width-1:0] Result,
    output reg [Width-1:0] ResultHigh, //Needed for multiplication overflow
    output reg Carry, //Needed for addition overflow
    output wire ZeroFlag
    );
    
    always @(*)begin
        Carry = 1'b0;
        ResultHigh = {Width{1'b0}};
        case (OpSel)
            3'b000: {Carry, Result} =A+B;
            3'b001: {Carry, Result} =A-B;
            3'b010: Result =A&B;
            3'b011: Result =A|B;
            3'b100: Result =A^B;
            3'b101: Result = ~(A^B);
            3'b110: begin
                            Result = ~A;
                            ResultHigh = ~B;
                       end 
            3'b111:{ResultHigh, Result} = A*B;
            default: Result = {Width{1'bx}};
        endcase
    end
    
    assign ZeroFlag = (Result == {Width{1'b0}});
                
endmodule
