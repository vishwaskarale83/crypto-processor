`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:54:12 PM
// Design Name: 
// Module Name: INSTRN_Dcoder_Module
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


module INSTRN_Dcoder_Module(
    input [14:0] instruction,
    input clk,
    input instrn_decode,
    output reg [3:0] operand_addr,
    output reg [4:0] opcode,
    output reg [1:0] operand_addr_mode,
    output reg [3:0] branch_offset_value,
    output reg start
        );
    
   initial
    begin
        opcode <= 0;
        operand_addr_mode <= 0;
        operand_addr <= 0;
        branch_offset_value <= 0;
        start <= 0;
    end
   
    always@(posedge clk)
    begin
      if(instrn_decode == 1)
        begin
            
            opcode <= {instruction[14],instruction[13],instruction[12],instruction[11],instruction[10]};
            operand_addr_mode <= {instruction[9],instruction[8]};
            operand_addr <= {instruction[7],instruction[6],instruction[5],instruction[4]};   
            branch_offset_value <= {instruction[3],instruction[2],instruction[1],instruction[0]};
            start <= 1;
        end
              
    end
endmodule

