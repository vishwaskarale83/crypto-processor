`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:53:37 PM
// Design Name: 
// Module Name: MEMORY_Module
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


module MEMORY_Module(
    input [14:0] address,
    input incr_pc_write,
    input [14:0] data_in,
    output reg [14:0] data_out,
    input read_data,
    input write_data,
    input clk,
    output reg instr_written
    );

    reg [14:0]mem_space[0:31];
    reg [14:0]address_w = 0;
    
    initial
    begin
      mem_space [0] = 15'h7D00; //0   11111  01  0000  0000
      mem_space [1] = 15'h0000; 
      mem_space [2] = 15'h0000; 
      mem_space [3] = 15'h0000; 
      mem_space [4] = 15'h0000; 
      mem_space [5] = 15'h0000;
      mem_space [6] = 15'h0000; //0   00000  01  0111  0000
      mem_space [7] = 15'h0000; //0   00011  01  0111  0000
      mem_space [8] = 15'h0000; //0   00000  01  0111  0000
      mem_space [9] = 15'h0000; //0   00010  01  0111  0000
      mem_space [10]= 15'h0000; //0   00011  01  0111  0000
      mem_space [11]= 15'h0000; //0   00000  01  0111  0000
      mem_space [12]= 15'h0000; //0   01010  01  0111  0000
      mem_space [13]= 15'h0000;
      mem_space [14]= 15'h0000;
      mem_space [15]= 15'h0000;
      mem_space [16]= 15'h0000;
      
      data_out <= 0;
      
    end
    always@(posedge clk)
    begin
      
      instr_written = 0;
      
      if(incr_pc_write == 1)
        address_w = address_w + 1'b1;
      
      if(read_data == 1)
      begin
        data_out <= mem_space[address];        
      end
      if(write_data == 1)
      begin
        mem_space[address_w] = data_in; 
        instr_written = 1;
      end
    end
    
endmodule

