`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:53:01 PM
// Design Name: 
// Module Name: PC_Module
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


module PC_Module(
    input incr_PC,
    input branch_offset,
    input [3:0] offset_value,
    output [14:0] PC_pointer,
    input clk,
    input reset_pc
    );
    
    reg [14:0]PC_reg = 0;
    
   
    
    assign PC_pointer = PC_reg;
    
    always@(posedge clk)
    begin
      if(reset_pc == 1)
        PC_reg <= 1;      
      if(incr_PC == 1)
      begin
        PC_reg <= PC_reg + 1'b1;
      end
      if(branch_offset == 1)
      begin
        PC_reg <= PC_reg + offset_value;
      end
      
    end

endmodule

