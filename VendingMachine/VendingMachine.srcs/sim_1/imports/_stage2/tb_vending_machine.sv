`timescale 1ns / 1ps
module tb_vending_machine;

    localparam integer PRICE = 30;

    reg clk = 0, rst, coin_in;
    reg [1:0] coin_sel;
    wire dispense;
    wire [7:0] change, credit;

    integer errors = 0;

    vending_machine #(.PRICE(PRICE)) dut (
        .clk(clk), .rst(rst), .coin_in(coin_in), .coin_sel(coin_sel),
        .dispense(dispense), .change(change), .credit(credit)
    );

    always #5 clk = ~clk;   // 10ns period; posedges at 5,15,25,...; negedges at 10,20,30,...

    // Applies one coin pulse. Returns at the negedge right after the
    // consuming posedge, i.e. mid-way through whatever state that edge
    // produced (DISPENSE state, if this coin crossed the threshold, lasts
    // from that consuming posedge until the following posedge).
    task insert_coin(input [1:0] sel);
        begin
            @(negedge clk);
            coin_in = 1'b1; coin_sel = sel;
            @(posedge clk); #1;   // consuming edge: state/total update here
            @(negedge clk);
            coin_in = 1'b0;
        end
    endtask

    initial begin
        rst = 1; coin_in = 0; coin_sel = 0;
        @(negedge clk); @(negedge clk);
        rst = 0;

        // exact price: 25 + 5 = 30, no change
        insert_coin(2'b10); // +25, credit=25 < 30, no dispense yet
        if (dispense !== 1'b0) begin
            $display("FAIL premature dispense at credit=25");
            errors = errors + 1;
        end
        insert_coin(2'b00); // +5 -> credit=30 -> DISPENSE is active right now
        if (dispense !== 1'b1 || change !== 8'd0) begin
            $display("FAIL exact-price dispense: dispense=%b change=%0d (expected 1,0)", dispense, change);
            errors = errors + 1;
        end
        @(posedge clk); #1; // DISPENSE lasts one cycle -> back to IDLE here
        if (dispense !== 1'b0 || credit !== 8'd0) begin
            $display("FAIL post-dispense reset: dispense=%b credit=%0d", dispense, credit);
            errors = errors + 1;
        end

        // overpay: 25 + 25 = 50, expect change = 20
        insert_coin(2'b10); // +25
        insert_coin(2'b10); // +25 -> credit=50 >= 30, DISPENSE active now
        if (dispense !== 1'b1 || change !== 8'd20) begin
            $display("FAIL overpay dispense: dispense=%b change=%0d (expected 1,20)", dispense, change);
            errors = errors + 1;
        end
        @(posedge clk); #1;

        // many small coins: 5*6 = 30
        begin : nickel_block
            integer k;
            for (k = 0; k < 6; k = k + 1)
                insert_coin(2'b00);
        end
        if (dispense !== 1'b1 || change !== 8'd0) begin
            $display("FAIL 6-nickel dispense: dispense=%b change=%0d (expected 1,0)", dispense, change);
            errors = errors + 1;
        end
        @(posedge clk); #1;

        // dime + dime + dime = 30
        insert_coin(2'b01); insert_coin(2'b01); insert_coin(2'b01);
        if (dispense !== 1'b1 || change !== 8'd0) begin
            $display("FAIL 3-dime dispense: dispense=%b change=%0d (expected 1,0)", dispense, change);
            errors = errors + 1;
        end
        @(posedge clk); #1;

        if (errors == 0) $display("TEST PASSED: vending_machine");
        else $display("TEST FAILED: vending_machine (%0d errors)", errors);
        $finish;
    end

    initial begin
        #10000;
        $display("FAIL: vending_machine testbench timeout");
        $finish;
    end

endmodule
