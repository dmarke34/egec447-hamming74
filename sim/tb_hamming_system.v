`timescale 1ns / 1ps

module tb_hamming_system;

    reg clk;
    reg rst;
    reg [3:0] data_in;
    reg [6:0] err_mask;


    wire [6:0] tx_cw;
    wire [6:0] rx_cw;
    wire [3:0] data_out;
    wire corrected;
    wire [2:0] syndrome;

    //8 ns clock
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

        //no error
        @(negedge clk) begin data_in = 4'b1011; err_mask = 7'b0000000; end
        @(posedge clk); @(posedge clk) #1;
        $display("no error: data_in=%b err=%b tx=%b rx=%b -> data_out=%b syn=%b corr=%b", data_in, err_mask, tx_cw, rx_cw, data_out, syndrome, corrected);

        //parity bit error
        @(negedge clk) err_mask = 7'b1000000;
        @(posedge clk); @(posedge clk) #1;
        $display("p1 error(1): data_in=%b err=%b tx=%b rx=%b -> data_out=%b syn=%b corr=%b", data_in, err_mask, tx_cw, rx_cw, data_out, syndrome, corrected);

        //data bit error
        @(negedge clk) err_mask = 7'b0000100;
        @(posedge clk); @(posedge clk) #1;
        $display("d2 error(5): data_in=%b err=%b tx=%b rx=%b -> data_out=%b syn=%b corr=%b", data_in, err_mask, tx_cw, rx_cw, data_out, syndrome, corrected);

        //async reset
        @(posedge clk) #2;
        rst = 1;
        #1 $display("async reset: tx=%b data_out=%b syn=%b corr=%b (expect 0000000 0000 000 0)", tx_cw, data_out, syndrome, corrected);
        #10 rst = 0;

        #30 $finish;
    end

endmodule