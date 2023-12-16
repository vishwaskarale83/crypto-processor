`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:58:00 PM
// Design Name: 
// Module Name: DATA_MEMORY_Module
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


module DATA_MEMORY_Module(
    input [127:0] data_in,
    output reg [127:0] data_out,
    output reg [1:0] ptr_diff=2,
    input read_flag,
    input write_flag,
    input clk,
    input incr_data_write,
    input incr_data_read,
    input reset
    );

    reg [127:0]mem_space[0:31];
    reg [4:0]d_address_w = 5'd0000;
    reg [4:0]d_address_r = 5'd0001;//1
    
    
    initial
    begin
      mem_space [0] = 15'h0000; //0   11010  01  0000  0000
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
       
       if(incr_data_write == 1)
        d_address_w = d_address_w + 1'b1; 
        
        if(incr_data_read == 1)
        d_address_r = d_address_r + 1'b1; 
     
     // if(read_flag == 1)
        data_out <= mem_space[d_address_r];      
      
      if(write_flag == 1)
      begin
        mem_space[d_address_w] = data_in; 
      end
      
       if(d_address_r >= d_address_w)
        ptr_diff = 1;
      else 
        ptr_diff = 2;
 
    end
    
endmodule

