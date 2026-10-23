`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 05:11:56 PM
// Design Name: 
// Module Name: hamming_encoder
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


module hamming_encoder(
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [6:0] cw_out //all outputs are registered on the rising edge of clk
    );
    
    //name the data bits to align with assignment requirements 
    wire d1 = data_in[3];
    wire d2 = data_in[2];
    wire d3 = data_in[1];
    wire d4 = data_in[0];
    
    //3 parity bit computation 
    wire p1 = d1 ^ d2 ^ d4;
    wire p2 = d1 ^ d3 ^ d4;
    wire p3 = d2 ^ d3 ^ d4;
    
    //register the output with async reset
    always @(posedge  clk or posedge  rst) begin
        if(rst)
            cw_out <= 7'b0000000; //clear the output 
        else
            cw_out <= {p1, p2, d1, p3, d2, d3, d4}; //load the codeword
    end
    
endmodule
