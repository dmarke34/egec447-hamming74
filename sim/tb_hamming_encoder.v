`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2026 07:20:09 PM
// Design Name: 
// Module Name: tb_hamming_encoder
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


module tb_hamming_encoder;
    
    //reg are signals the testbench drives into the encoder
    reg clk;
    reg rst;
    reg [3:0] data_in;
    integer i;
    
    //wire are signals/bits that the encoder outputs
    wire [6:0] cw_out;
    
    initial
        clk = 0;
    always
        #4 clk = ~clk;
    
    
    hamming_encoder dut (
        .clk (clk),
        .rst (rst),
        .data_in (data_in),
        .cw_out (cw_out)
    );
    
    initial begin
        rst = 1;                
        data_in = 4'b0000;
        #20;
        rst = 0;                
        
        //loop through all 16 combinations/values
        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk) data_in = i; //change input on falling edge
            @(posedge clk) #1; //wait for the register to update
            $display("data=%b  cw=%b", data_in, cw_out);
        end

        // async reset test: assert reset between clock edges
        @(posedge clk) #2;     
        rst = 1;
        #1 $display("after async reset: cw=%b (expect 0000000)", cw_out);
        #10 rst = 0;
        
        #20 $finish;
    end
endmodule
