`timescale 1ns / 1ps
module tb_clk_divider;

    localparam integer DIV_BITS = 4;   // pow2 ratio = 16
    localparam integer N        = 7;   // odd ratio

    reg clk_in = 0, rst;
    wire clk_out_pow2, clk_out_odd;

    integer errors = 0;
    integer i;
    integer t_prev, t_now;
    real    meas_ns, expected_ns;

    clk_div_pow2 #(.DIV_BITS(DIV_BITS)) dut_pow2 (
        .clk_in(clk_in), .rst(rst), .clk_out(clk_out_pow2)
    );

    clk_div_odd #(.N(N)) dut_odd (
        .clk_in(clk_in), .rst(rst), .clk_out(clk_out_odd)
    );

    always #5 clk_in = ~clk_in;   // 10ns period => 100 MHz reference

    initial begin
        rst = 1;
        repeat (4) @(negedge clk_in);
        rst = 0;

        // --- power-of-2 divider: expect exact period = 2**DIV_BITS input cycles
        expected_ns = (1 << DIV_BITS) * 10.0;
        @(posedge clk_out_pow2);
        t_prev = $time;
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge clk_out_pow2);
            t_now = $time;
            meas_ns = t_now - t_prev;
            if (meas_ns < expected_ns - 0.001 || meas_ns > expected_ns + 0.001) begin
                $display("FAIL [%0t] clk_div_pow2 period #%0d: expected=%0fns got=%0fns", $time, i, expected_ns, meas_ns);
                errors = errors + 1;
            end
            t_prev = t_now;
        end

        // --- odd divider: expect exact period = N input cycles
        expected_ns = N * 10.0;
        @(posedge clk_out_odd);
        t_prev = $time;
        for (i = 0; i < 6; i = i + 1) begin
            @(posedge clk_out_odd);
            t_now = $time;
            meas_ns = t_now - t_prev;
            if (meas_ns < expected_ns - 0.001 || meas_ns > expected_ns + 0.001) begin
                $display("FAIL [%0t] clk_div_odd period #%0d: expected=%0fns got=%0fns", $time, i, expected_ns, meas_ns);
                errors = errors + 1;
            end
            t_prev = t_now;
        end

        if (errors == 0) $display("TEST PASSED: clk_divider");
        else $display("TEST FAILED: clk_divider (%0d errors)", errors);
        $finish;
    end

    initial begin
        #20000;
        $display("FAIL: clk_divider testbench timeout");
        $finish;
    end

endmodule
