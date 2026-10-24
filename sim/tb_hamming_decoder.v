`timescale 1ns / 1ps
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 06:25:49 PM
// Design Name: 
// Module Name: tb_hamming_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_hamming_decoder;

    reg clk;
    reg rst;
    reg [6:0] cw_in;

    wire [3:0] data_out;
    wire corrected;
    wire [2:0] syndrome;

    initial
        clk = 0;
    always
        #4 clk = ~clk;

    hamming_decoder dut (
        .clk       (clk),
        .rst       (rst),
        .cw_in     (cw_in),
        .data_out  (data_out),
        .corrected (corrected),
        .syndrome  (syndrome)
    );

    initial begin
        rst = 1;
        cw_in = 7'b0000000;
        #20;
        rst = 0;
        
        //no error
        @(negedge clk) cw_in = 7'b0110011;
        @(posedge clk) #1;
        $display("no error      : cw_in=%b  data=%b  syn=%b  corr=%b", cw_in, data_out, syndrome, corrected);
        
        //parity-bit error 
        @(negedge clk) cw_in = 7'b0110011 ^ 7'b1000000;
        @(posedge clk) #1;
        $display("p1 error (1)  : cw_in=%b  data=%b  syn=%b  corr=%b", cw_in, data_out, syndrome, corrected);
        
        //data-bit error
        @(negedge clk) cw_in = 7'b0110011 ^ 7'b0000100;
        @(posedge clk) #1;
        $display("d2 error (5)  : cw_in=%b  data=%b  syn=%b  corr=%b", cw_in, data_out, syndrome, corrected);

        //async reset
        @(posedge clk) #2;
        rst = 1;
        #1 $display("async reset   : data=%b  syn=%b  corr=%b (expect 0000 000 0)", data_out, syndrome, corrected);
        #10 rst = 0;
        
        #20 $finish;
    end
    
endmodule
