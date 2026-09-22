`timescale 1ns / 1ps
//=============================================================================
// Up/Down Binary Counter
//   - Synchronous active-high reset
//   - en gates counting, up_down selects direction (1 = up, 0 = down)
//   - Free-running wraparound at both ends (natural binary overflow/underflow)
//=============================================================================
module updown_counter #(
    parameter integer WIDTH = 8
)(
    input  wire              clk,
    input  wire              rst,
    input  wire              en,
    input  wire              up_down,   // 1 = count up, 0 = count down
    output reg  [WIDTH-1:0]  count
);

    always @(posedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (en)
            count <= up_down ? (count + 1'b1) : (count - 1'b1);
    end

endmodule
