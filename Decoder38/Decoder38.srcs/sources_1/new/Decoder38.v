`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 14:50:48
// Design Name: 
// Module Name: Decoder38
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


module Decoder38(
    input wire [2:0] Sel,
    input wire Enable,
    output reg [7:0] Y
    );
    
    always @(*) begin
        if (Enable) begin
            case (Sel)
                3'b000: Y= 8'b00000001;
                3'b001: Y= 8'b00000010;
                3'b010: Y= 8'b00000100;
                3'b011: Y= 8'b00001000;
                3'b100: Y= 8'b00010000;
                3'b101: Y= 8'b00100000;
                3'b110: Y= 8'b01000000;
                3'b111: Y= 8'b10000000;
                default: Y = 8'b00000000;
            endcase
        end
        else begin
            Y=8'b00000000;
        end
    end
    
    /*always @(*) begin
        if (Enable)
            Y = 8'b00000001 << Sel;
        else
            Y = 8'b00000000;
    end*/
                
endmodule
