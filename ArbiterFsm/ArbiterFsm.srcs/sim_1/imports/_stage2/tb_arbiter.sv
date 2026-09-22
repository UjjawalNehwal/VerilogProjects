`timescale 1ns / 1ps
module tb_arbiter;

    localparam integer N = 4;

    // ---- fixed priority (combinational) ----
    reg  [N-1:0] req_fp;
    wire [N-1:0] grant_fp;

    fixed_priority_arbiter #(.N(N)) dut_fp (.req(req_fp), .grant(grant_fp));

    // ---- round robin (sequential) ----
    reg clk = 0, rst;
    reg  [N-1:0] req_rr;
    wire [N-1:0] grant_rr;

    round_robin_arbiter #(.N(N)) dut_rr (
        .clk(clk), .rst(rst), .req(req_rr), .grant(grant_rr)
    );

    always #5 clk = ~clk;

    integer errors = 0;
    integer i, j;

    function integer lowest_set_bit(input [N-1:0] v);
        integer k;
        integer found;
        begin
            found = -1;
            for (k = 0; k < N; k = k + 1)
                if (found == -1 && v[k]) found = k;
            lowest_set_bit = found;
        end
    endfunction

    initial begin
        // ---- fixed priority: exhaustive over all 2^N request patterns ----
        for (i = 0; i < (1 << N); i = i + 1) begin
            req_fp = i[N-1:0];
            #1;
            if (i == 0) begin
                if (grant_fp !== {N{1'b0}}) begin
                    $display("FAIL fixed-priority: req=0 gave grant=%b", grant_fp);
                    errors = errors + 1;
                end
            end else begin
                integer exp_idx;
                exp_idx = lowest_set_bit(req_fp);
                if (grant_fp !== ({{(N-1){1'b0}}, 1'b1} << exp_idx)) begin
                    $display("FAIL fixed-priority: req=%b expected grant bit %0d got=%b", req_fp, exp_idx, grant_fp);
                    errors = errors + 1;
                end
            end
        end

        // ---- round robin: all requesters always asking -> must rotate
        // through all N requesters exactly once every N grants (fairness),
        // and must never grant more than one bit or grant a non-requester
        rst = 1; req_rr = {N{1'b1}};
        @(negedge clk); @(negedge clk);
        rst = 0;

        begin : rr_fairness
            reg [N-1:0] seen;
            integer grants_checked;
            seen = {N{1'b0}};
            grants_checked = 0;
            for (j = 0; j < 3*N; j = j + 1) begin
                @(posedge clk); #1;
                if (grant_rr == {N{1'b0}}) begin
                    $display("FAIL round-robin: no grant at cycle %0d despite all requesting", j);
                    errors = errors + 1;
                end else begin
                    // exactly one bit set
                    if (^grant_rr !== 1'b1) begin
                        $display("FAIL round-robin: grant not one-hot: %b", grant_rr);
                        errors = errors + 1;
                    end
                    seen = seen | grant_rr;
                    grants_checked = grants_checked + 1;
                    if (grants_checked % N == 0) begin
                        if (seen !== {N{1'b1}}) begin
                            $display("FAIL round-robin: not all requesters served within %0d-cycle window (seen=%b)", N, seen);
                            errors = errors + 1;
                        end
                        seen = {N{1'b0}};
                    end
                end
            end
        end

        // ---- round robin: partial requesters, grant must only go to a requester ----
        req_rr = 4'b0101; // requesters 0 and 2 only
        for (j = 0; j < 10; j = j + 1) begin
            @(posedge clk); #1;
            if (grant_rr != {N{1'b0}} && (grant_rr & req_rr) !== grant_rr) begin
                $display("FAIL round-robin: granted a non-requester, grant=%b req=%b", grant_rr, req_rr);
                errors = errors + 1;
            end
        end

        if (errors == 0) $display("TEST PASSED: arbiter");
        else $display("TEST FAILED: arbiter (%0d errors)", errors);
        $finish;
    end

    initial begin
        #10000;
        $display("FAIL: arbiter testbench timeout");
        $finish;
    end

endmodule
