`timescale 1ns / 1ps
//=============================================================================
// Synchronous Dual-Port RAM / Register File
//   - Port A : read + write (write-first-to-old-data / read-before-write:
//               dout_a returns the value held BEFORE this cycle's write,
//               matching typical block-RAM "read-old-data" behavior)
//   - Port B : read-only, independent address
//   - Single clock domain, synchronous read latency = 1 cycle on both ports
//=============================================================================
module dual_port_ram #(
    parameter integer DATA_WIDTH = 8,
    parameter integer ADDR_WIDTH = 8
)(
    input  wire                         clk,
    input  wire                         we,
    input  wire [ADDR_WIDTH-1:0]        addr_a,
    input  wire [ADDR_WIDTH-1:0]        addr_b,
    input  wire [DATA_WIDTH-1:0]        din_a,
    output reg  [DATA_WIDTH-1:0]        dout_a,
    output reg  [DATA_WIDTH-1:0]        dout_b
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    integer init_i;
    initial begin
        for (init_i = 0; init_i < (1<<ADDR_WIDTH); init_i = init_i + 1)
            mem[init_i] = {DATA_WIDTH{1'b0}};
    end

    always @(posedge clk) begin
        if (we)
            mem[addr_a] <= din_a;
        dout_a <= mem[addr_a];   // old data (pre-write) on this address
        dout_b <= mem[addr_b];
    end

endmodule
