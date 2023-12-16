`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:58:49 PM
// Design Name: 
// Module Name: REGISTER_BANK_MODULE
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


module REGISTER_BANK_MODULE(
    input [2:0] address_1,
    input [2:0] address,
    input [15:0] data,
    input read_write_reg_bank,
    input clk,
    output reg [15:0] reg_data_1
    );
    
    reg [15:0] reg_bank [0:7];
     
    initial
    begin
      reg_bank[0] <= 0;
      reg_bank[1] <= 0;
      reg_bank[2] <= 0;
      reg_bank[3] <= 0;
      reg_bank[4] <= 0;
      reg_bank[5] <= 0;
      reg_bank[6] <= 0;
      reg_bank[7] <= 0; 
      reg_data_1 <= 0;
    end
   
    always@(posedge clk)
    begin
      if(read_write_reg_bank == 0)
        begin
          reg_data_1 <= reg_bank[address_1];
        end
      if(read_write_reg_bank == 1)
        begin
          reg_bank[address] <= data;
        end
      
    end
    


endmodule

