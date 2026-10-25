`timescale 1ns / 1ps

module hamming_top(
    input clk,                 // 125 MHz board clock (pin H16)
    input [1:0] sw,            // SW0-SW1
    input [3:0] btn,           // BTN0-BTN3
    output [3:0] led,          // LED0-LED3: recovered data
    output led4_r,             // RGB LED4 red   = s1
    output led4_g,             // RGB LED4 green = s2
    output led4_b              // RGB LED4 blue  = s3
    );

    //no reset button on the board
    wire rst = 1'b0;

    //data input
    wire [3:0] data_in = {btn[1], btn[0], sw[1], sw[0]};

    //error mask
    wire [6:0] err_mask = {btn[2], 3'b000,  btn[3], 2'b00};

    //encoder -> error XOR -> decoder
    wire [6:0] tx_cw, rx_cw;     
    wire [3:0] data_out;
    wire corrected;              
    wire [2:0] syndrome;        

    hamming_system sys (
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

    //outputs to the board
    assign led    = data_out;      
    assign led4_r = syndrome[0];   // s1
    assign led4_g = syndrome[1];   // s2
    assign led4_b = syndrome[2];   // s3

endmodule