`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 10:35:53 PM
// Design Name: 
// Module Name: hamming_decoder
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


module hamming_decoder(
    input clk,
    input rst,
    input [6:0] cw_in,
    output reg [3:0] data_out,
    output reg corrected,
    output reg [2:0] syndrome
    );
        
    wire c1 = cw_in[6];
    wire c2 = cw_in[5];
    wire c3 = cw_in[4];
    wire c4 = cw_in[3];
    wire c5 = cw_in[2];
    wire c6 = cw_in[1];
    wire c7 = cw_in[0];
    
    wire s1 = c1 ^ c3 ^ c5 ^ c7;
    wire s2 = c2 ^ c3 ^ c6 ^ c7;
    wire s3 = c4 ^ c5 ^ c6 ^ c7;
    
    
endmodule
