`timescale 1ns / 1ps
module tb_ring_johnson_counter;

    localparam integer WIDTH = 4;

    reg clk = 0, rst;
    wire [WIDTH-1:0] q_ring, q_johnson;

    integer errors = 0;
    integer i;
    reg [WIDTH-1:0] shadow_ring, shadow_johnson;

    ring_counter #(.WIDTH(WIDTH)) dut_ring (
        .clk(clk), .rst(rst), .q(q_ring)
    );

    johnson_counter #(.WIDTH(WIDTH)) dut_johnson (
        .clk(clk), .rst(rst), .q(q_johnson)
    );

    always #5 clk = ~clk;

    initial begin
        rst = 1;
        @(negedge clk); @(negedge clk);
        rst = 0;

        if (q_ring !== 4'b0001) begin
            $display("FAIL [%0t] ring reset value, got=%b", $time, q_ring);
            errors = errors + 1;
        end
        if (q_johnson !== 4'b0000) begin
            $display("FAIL [%0t] johnson reset value, got=%b", $time, q_johnson);
            errors = errors + 1;
        end

        shadow_ring    = 4'b0001;
        shadow_johnson = 4'b0000;

        // run 3 full periods of the LCM cycle and verify recurrences +
        // periodicity (ring period = WIDTH, johnson period = 2*WIDTH)
        for (i = 1; i <= 3*2*WIDTH; i = i + 1) begin
            @(posedge clk); #1;
            shadow_ring    = {shadow_ring[WIDTH-2:0], shadow_ring[WIDTH-1]};
            shadow_johnson = {shadow_johnson[WIDTH-2:0], ~shadow_johnson[WIDTH-1]};

            if (q_ring !== shadow_ring) begin
                $display("FAIL [%0t] ring step %0d expected=%b got=%b", $time, i, shadow_ring, q_ring);
                errors = errors + 1;
            end
            // one-hot invariant for ring counter (popcount must equal 1)
            if (^q_ring !== 1'b1 || q_ring == 4'b0000) begin
                $display("FAIL [%0t] ring counter not one-hot: %b", $time, q_ring);
                errors = errors + 1;
            end

            if (q_johnson !== shadow_johnson) begin
                $display("FAIL [%0t] johnson step %0d expected=%b got=%b", $time, i, shadow_johnson, q_johnson);
                errors = errors + 1;
            end

            if (i % WIDTH == 0 && q_ring !== 4'b0001) begin
                $display("FAIL [%0t] ring period != WIDTH at step %0d: %b", $time, i, q_ring);
                errors = errors + 1;
            end
            if (i % (2*WIDTH) == 0 && q_johnson !== 4'b0000) begin
                $display("FAIL [%0t] johnson period != 2*WIDTH at step %0d: %b", $time, i, q_johnson);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("TEST PASSED: ring_johnson_counter");
        else $display("TEST FAILED: ring_johnson_counter (%0d errors)", errors);
        $finish;
    end

    initial begin
        #5000;
        $display("FAIL: ring_johnson_counter testbench timeout");
        $finish;
    end

endmodule
