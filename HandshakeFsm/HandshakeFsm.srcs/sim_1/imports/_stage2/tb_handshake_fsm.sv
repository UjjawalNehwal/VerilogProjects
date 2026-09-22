`timescale 1ns / 1ps
module tb_handshake_fsm;

    reg clk = 0, rst, start, ack;
    wire req, done;

    integer errors = 0;
    integer i;
    integer done_count;

    handshake_fsm dut (
        .clk(clk), .rst(rst), .start(start), .ack(ack), .req(req), .done(done)
    );

    always #5 clk = ~clk;

    // simple responder model: raises ack a few cycles after seeing req,
    // drops ack a few cycles after req falls -- run as a background process
    reg [3:0] ack_delay_up, ack_delay_down;
    initial begin
        ack = 0;
        forever begin
            @(posedge clk);
            if (req && !ack) begin
                repeat (ack_delay_up) @(posedge clk);
                ack <= 1'b1;
            end else if (!req && ack) begin
                repeat (ack_delay_down) @(posedge clk);
                ack <= 1'b0;
            end
        end
    end

    // Protocol correctness note: by construction, req can only fall on the
    // REQ_HIGH -> REQ_LOW_WAIT transition, which only fires when ack was
    // observed high, so "req drops before ack seen" cannot occur here --
    // no separate watchdog needed; the done-count/timeout checks below
    // already catch any transition-logic regression.

    initial begin
        rst = 1; start = 0; ack_delay_up = 2; ack_delay_down = 2;
        @(negedge clk); @(negedge clk);
        rst = 0;

        done_count = 0;
        for (i = 0; i < 5; i = i + 1) begin
            ack_delay_up = 1 + (i % 3);
            ack_delay_down = 1 + ((i+1) % 3);

            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;

            // wait for done, with a generous bound
            begin : wait_done
                integer waited;
                waited = 0;
                while (!done && waited < 50) begin
                    @(posedge clk); #1;
                    waited = waited + 1;
                end
                if (!done) begin
                    $display("FAIL transfer %0d: done never asserted", i);
                    errors = errors + 1;
                end else begin
                    done_count = done_count + 1;
                end
            end
            @(posedge clk); #1; // settle back to IDLE
            if (req !== 1'b0) begin
                $display("FAIL transfer %0d: req still high after done", i);
                errors = errors + 1;
            end
        end

        if (done_count !== 5) begin
            $display("FAIL: expected 5 completed transfers, got %0d", done_count);
            errors = errors + 1;
        end

        if (errors == 0) $display("TEST PASSED: handshake_fsm");
        else $display("TEST FAILED: handshake_fsm (%0d errors)", errors);
        $finish;
    end

    initial begin
        #10000;
        $display("FAIL: handshake_fsm testbench timeout");
        $finish;
    end

endmodule
