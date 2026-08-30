`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2026 17:30:20
// Design Name: 
// Module Name: BarrelShifter
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


module BarrelShifter(
    input wire [7:0] Data,
    input wire [2:0] ShiftAmt,
    input wire Direction,
    input wire Mode,
    output reg [7:0] Result
    );
    
    always @(*) begin
        case ({Direction, Mode})
            2'b00: Result = Data << ShiftAmt;                        // Left shift (logical, Mode irrelevant here)
            2'b10: Result = Data << ShiftAmt;                        // Left shift (arithmetic, same as logical for left)
            2'b01: Result = Data >> ShiftAmt;                        // Right shift, logical
            2'b11: Result = $signed(Data) >>> ShiftAmt;              // Right shift, arithmetic
            default: Result = {8{1'bx}};
        endcase
    end
    
endmodule
