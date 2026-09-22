`timescale 1ns / 1ps
module tb_dual_port_ram;

    localparam integer DATA_WIDTH = 8;
    localparam integer ADDR_WIDTH = 6;   // small depth (64) for a fast exhaustive-ish test
    localparam integer DEPTH      = (1 << ADDR_WIDTH);

    reg clk = 0, we;
    reg [ADDR_WIDTH-1:0] addr_a, addr_b;
    reg [DATA_WIDTH-1:0] din_a;
    wire [DATA_WIDTH-1:0] dout_a, dout_b;

    reg [DATA_WIDTH-1:0] shadow_mem [0:DEPTH-1];
    integer errors = 0;
    integer i;
    reg [ADDR_WIDTH-1:0] a, b;
    reg [DATA_WIDTH-1:0] wdata;
    reg [DATA_WIDTH-1:0] exp_dout_a, exp_dout_b;

    dual_port_ram #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
        .clk(clk), .we(we),
        .addr_a(addr_a), .addr_b(addr_b),
        .din_a(din_a), .dout_a(dout_a), .dout_b(dout_b)
    );

    always #5 clk = ~clk;

    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            shadow_mem[i] = {DATA_WIDTH{1'b0}};

        we = 0; addr_a = 0; addr_b = 0; din_a = 0;
        @(negedge clk);

        // fill every location via port A, verify read-back via both ports
        for (i = 0; i < DEPTH; i = i + 1) begin
            a     = i[ADDR_WIDTH-1:0];
            wdata = i[DATA_WIDTH-1:0] ^ 8'hA3;

            we = 1; addr_a = a; din_a = wdata; addr_b = a;
            exp_dout_a = shadow_mem[a];      // old data expected (read-before-write)
            exp_dout_b = shadow_mem[a];
            shadow_mem[a] = wdata;
            @(posedge clk); #1;

            if (dout_a !== exp_dout_a) begin
                $display("FAIL [%0t] write-cycle dout_a addr=%0d expected=%h got=%h", $time, a, exp_dout_a, dout_a);
                errors = errors + 1;
            end
            if (dout_b !== exp_dout_b) begin
                $display("FAIL [%0t] write-cycle dout_b addr=%0d expected=%h got=%h", $time, a, exp_dout_b, dout_b);
                errors = errors + 1;
            end
        end
        we = 0;
        @(posedge clk); #1;

        // random independent-address reads on A and B, compare vs shadow
        for (i = 0; i < 200; i = i + 1) begin
            a = $random;
            b = $random;
            addr_a = a; addr_b = b;
            exp_dout_a = shadow_mem[addr_a];
            exp_dout_b = shadow_mem[addr_b];
            @(posedge clk); #1;
            if (dout_a !== exp_dout_a) begin
                $display("FAIL [%0t] read dout_a addr=%0d expected=%h got=%h", $time, addr_a, exp_dout_a, dout_a);
                errors = errors + 1;
            end
            if (dout_b !== exp_dout_b) begin
                $display("FAIL [%0t] read dout_b addr=%0d expected=%h got=%h", $time, addr_b, exp_dout_b, dout_b);
                errors = errors + 1;
            end
        end

        // random writes + simultaneous dual-port reads
        for (i = 0; i < 200; i = i + 1) begin
            a     = $random;
            b     = $random;
            wdata = $random;

            we = 1; addr_a = a; din_a = wdata; addr_b = b;
            exp_dout_a = shadow_mem[a];
            exp_dout_b = shadow_mem[b];
            shadow_mem[a] = wdata;
            @(posedge clk); #1;

            if (dout_a !== exp_dout_a) begin
                $display("FAIL [%0t] mixed write dout_a addr=%0d expected=%h got=%h", $time, a, exp_dout_a, dout_a);
                errors = errors + 1;
            end
            if (dout_b !== exp_dout_b) begin
                $display("FAIL [%0t] mixed write dout_b addr=%0d expected=%h got=%h", $time, b, exp_dout_b, dout_b);
                errors = errors + 1;
            end
        end
        we = 0;

        if (errors == 0) $display("TEST PASSED: dual_port_ram");
        else $display("TEST FAILED: dual_port_ram (%0d errors)", errors);
        $finish;
    end

    initial begin
        #50000;
        $display("FAIL: dual_port_ram testbench timeout");
        $finish;
    end

endmodule
