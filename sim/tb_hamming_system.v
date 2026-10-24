`timescale 1ns / 1ps

module tb_hamming_system;

    // reg: signals the testbench drives into the system
    reg clk;
    reg rst;
    reg [3:0] data_in;
    reg [6:0] err_mask;

    // wire: signals the system outputs
    wire [6:0] tx_cw;
    wire [6:0] rx_cw;
    wire [3:0] data_out;
    wire corrected;
    wire [2:0] syndrome;

    // 8 ns clock (125 MHz)
    initial
        clk = 0;
    always
        #4 clk = ~clk;

    hamming_system dut (
        .clk       (clk),
        .rst       (rst),
        .data_in   (data_in),
        .err_mask  (err_mask),
        .tx_cw     (tx_cw),
        .rx_cw     (rx_cw),
        .data_out  (data_out),
        .corrected (corrected),
        .syndrome  (syndrome)
    );

    initial begin
        rst = 1;
        data_in  = 4'b0000;
        err_mask = 7'b0000000;
        #20;
        rst = 0;

        // All tests send data 1011 (codeword 0110011).
        // Data passes through 2 registers (encoder, then decoder),
        // so wait 2 rising edges before checking the output.

        // 1. No error
        @(negedge clk) begin data_in = 4'b1011; err_mask = 7'b0000000; end
        @(posedge clk); @(posedge clk) #1;
        $display("no error: data_in=%b err=%b tx=%b rx=%b -> data_out=%b syn=%b corr=%b", data_in, err_mask, tx_cw, rx_cw, data_out, syndrome, corrected);

        // 2. Parity-bit error: flip position 1 (p1), like BTN2
        @(negedge clk) err_mask = 7'b1000000;
        @(posedge clk); @(posedge clk) #1;
        $display("p1 error(1): data_in=%b err=%b tx=%b rx=%b -> data_out=%b syn=%b corr=%b", data_in, err_mask, tx_cw, rx_cw, data_out, syndrome, corrected);

        // 3. Data-bit error: flip position 5 (d2), like BTN3 (handout's 0000100 example)
        @(negedge clk) err_mask = 7'b0000100;
        @(posedge clk); @(posedge clk) #1;
        $display("d2 error(5): data_in=%b err=%b tx=%b rx=%b -> data_out=%b syn=%b corr=%b", data_in, err_mask, tx_cw, rx_cw, data_out, syndrome, corrected);

        // 4. Async reset: assert reset between clock edges; both modules clear at once
        @(posedge clk) #2;
        rst = 1;
        #1 $display("async reset: tx=%b data_out=%b syn=%b corr=%b (expect 0000000 0000 000 0)", tx_cw, data_out, syndrome, corrected);
        #10 rst = 0;

        #30 $finish;
    end

endmodule