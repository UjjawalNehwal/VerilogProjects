`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2026 01:49:35
// Design Name: 
// Module Name: Mux21
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


 module Mux21(
    input wire A,
    input wire B, 
    input wire Sel,
    output reg Y
     //output wire Y //For using assign statements
    );
    
    /* Using the case statement*/
    always @(*) begin
        case (Sel)
            1'b0: Y=A;
            1'b1: Y=B;
            default: Y= 1'bx;
        endcase
    end
    
        //assign Y= Sel ? B : A;
    
endmodule
