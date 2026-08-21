`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2026 04:09:05
// Design Name: 
// Module Name: HalfAdder
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


module HalfAdder(
    input wire A,
    input wire B,
    output reg Sum,
    output reg Carry
    );
    
    /*Simplest form of representating
    always @(*) begin
        {Carry, Sum} = A+B;
    end
    */
    
    // Case form of representation
    always @(*) begin
        case ({A, B})
            2'b00: {Carry, Sum} = 2'b00;
            2'b01: {Carry, Sum} = 2'b01;
            2'b10: {Carry, Sum} = 2'b01;
            2'b11: {Carry, Sum} = 2'b10;
        endcase
    end

    
    /* If-else statements representation
    always @(*) begin
        if (A == 1'b1 && B == 1'b1)
            Carry = 1'b1;
        else
            Carry = 1'b0;
            
         if (A != B)
            Sum = 1'b1;
         else 
            Sum = 1'b0;
    end 
    */
       
endmodule
