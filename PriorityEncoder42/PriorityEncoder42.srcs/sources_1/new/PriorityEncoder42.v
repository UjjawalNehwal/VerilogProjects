`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2026 13:22:16
// Design Name: 
// Module Name: PriorityEncoder42
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


module PriorityEncoder42(
    input wire [3:0] I,
    output reg [1:0] Y,
    input wire Valid
    );
    
    always @(*) begin
        if (Valid) begin
            if (I[3])
                Y = 2'b11;
            else if (I[2])
                Y = 2'b10;
            else if (I[1])
                Y = 2'b01;
            else
                Y = 2'b00;
        end
        else begin
            Y = 2'b00;
        end
    end
    
    /*always @(*) begin
        if (Valid) begin
            casex ({I3, I2, I1, I0})
                4'b1xxx: Y = 2'b11;
                4'b01xx: Y = 2'b10;
                4'b001x: Y = 2'b01;
                4'b0001: Y = 2'b00;
                default: Y = 2'b00;
            endcase
        end
        else begin
            Y = 2'b00;
        end
    end*/
                                
endmodule
