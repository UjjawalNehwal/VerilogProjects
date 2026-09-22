`timescale 1ns / 1ps
module tb_cdc_sync;

    localparam integer WIDTH = 4;

    reg dst_clk = 0, rst;
    reg [WIDTH-1:0] async_in;
    wire [WIDTH-1:0] sync_out;

    integer errors = 0;
    integer i;

    // history of every value async_in has ever held, so we can confirm
    // sync_out never outputs a value that was never actually driven
    reg [WIDTH-1:0] history [0:63];
    integer hist_count;
    reg driving_done;

    cdc_2ff_sync #(.WIDTH(WIDTH)) dut (
        .dst_clk(dst_clk), .rst(rst), .async_in(async_in), .sync_out(sync_out)
    );

    // dst_clk: 10ns period
    always #5 dst_clk = ~dst_clk;

    // async_in driven from an unrelated, faster, uncorrelated cadence
    // (7ns steps) so its edges land at arbitrary phases vs dst_clk; stops
    // after a fixed number of steps and then holds its final value.
    initial begin
        async_in = 4'h0;
        history[0] = 4'h0;
        hist_count = 1;
        driving_done = 1'b0;
        repeat (250) begin
            #7;
            async_in = async_in + 4'h3;
            if (hist_count < 64) begin
                history[hist_count] = async_in;
                hist_count = hist_count + 1;
            end
        end
        driving_done = 1'b1;
    end

    function integer in_history(input [WIDTH-1:0] v);
        integer k;
        integer found;
        begin
            found = 0;
            for (k = 0; k < hist_count; k = k + 1)
                if (history[k] == v) found = 1;
            in_history = found;
        end
    endfunction

    initial begin
        rst = 1;
        repeat (3) @(posedge dst_clk);
        rst = 0;

        // functional check: every sampled sync_out value must have actually
        // appeared on async_in at some point (no corruption/undriven value)
        for (i = 0; i < 150; i = i + 1) begin
            @(posedge dst_clk); #1;
            if (!in_history(sync_out)) begin
                $display("FAIL [%0t] sync_out=%h never seen on async_in (corruption)", $time, sync_out);
                errors = errors + 1;
            end
        end

        // wait until the async driver has stopped and held its final value
        while (!driving_done) @(posedge dst_clk);

        // settling check: once async_in is steady, sync_out must converge
        // to that exact value within 2 dst_clk cycles (fixed latency)
        @(posedge dst_clk); @(posedge dst_clk); #1;
        if (sync_out !== async_in) begin
            $display("FAIL settle check: expected sync_out=%h (final async_in) got=%h", async_in, sync_out);
            errors = errors + 1;
        end

        if (errors == 0) $display("TEST PASSED: cdc_2ff_sync");
        else $display("TEST FAILED: cdc_2ff_sync (%0d errors)", errors);
        $finish;
    end

    initial begin
        #10000;
        $display("FAIL: cdc_2ff_sync testbench timeout");
        $finish;
    end

endmodule
