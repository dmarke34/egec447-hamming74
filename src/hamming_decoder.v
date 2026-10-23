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
    
    //3 syndrome computations 
    wire s1 = c1 ^ c3 ^ c5 ^ c7;
    wire s2 = c2 ^ c3 ^ c6 ^ c7;
    wire s3 = c4 ^ c5 ^ c6 ^ c7;
    
    wire [2:0] syn = {s3, s2, s1};
    
    reg [6:0] fixed; //flip the bit the syndrome points to 

    always @(*) begin
        case (syn)
            3'd1:    fixed = cw_in ^ 7'b1000000;   //position 1 (p1)
            3'd2:    fixed = cw_in ^ 7'b0100000;   //position 2 (p2)
            3'd3:    fixed = cw_in ^ 7'b0010000;   //position 3 (d1)
            3'd4:    fixed = cw_in ^ 7'b0001000;   //position 4 (p3)
            3'd5:    fixed = cw_in ^ 7'b0000100;   //position 5 (d2)
            3'd6:    fixed = cw_in ^ 7'b0000010;   //position 6 (d3)
            3'd7:    fixed = cw_in ^ 7'b0000001;   //position 7 (d4)
            default: fixed = cw_in;                //000: no error
        endcase
    end
    
    wire data_err = (syn == 3'd3) || (syn == 3'd5) || (syn == 3'd6) || (syn == 3'd7); 
    
    
endmodule
