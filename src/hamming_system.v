`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 08:37:58 PM
// Design Name: 
// Module Name: hamming_system
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


module hamming_system(
    input clk,
    input rst,
    input [3:0] data_in,
    input [6:0] err_mask,
    output [6:0] tx_cw,
    output [6:0] rx_cw,
    output [3:0] data_out,
    output corrected,
    output [2:0] syndrome
    );
    //encoder 
    hamming_encoder enc (
        .clk (clk),
        .rst (rst),
        .data_in (data_in),
        .cw_out (tx_cw)
    );
    
    //error injection
    assign rx_cw = tx_cw ^ err_mask;
    
    //decoder
    hamming_decoder dec (
        .clk (clk),
        .rst (rst),
        .cw_in (rx_cw),
        .data_out (data_out),
        .corrected (corrected),
        .syndrome (syndrome)
    );
endmodule
