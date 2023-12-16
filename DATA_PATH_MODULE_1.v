`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:50:45 PM
// Design Name: 
// Module Name: DATA_PATH_MODULE_1
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


module DATA_PATH_MODULE_1(
    
    input clk,
    input incr_pc,
    input incr_data_write,
    input incr_data_read,
    input [14:0] mem_input_data,
    input [127:0]d_mem_input_data,
    input instrn_decode,
    input branch_offset_en,
    input reset_pc,
    input reset,
    input incr_pc_write,
    input read_data,
    input write_data,
    input read_flag,
    input write_flag,
    
    output  [4:0] opcode,
    output  [3:0] operand_addr,
    output  [1:0] operand_addr_mode,
    
    output start,
    output [127:0]d_mem_data,
    output [1:0]ptr_diff,
    output instr_written
    /*output [6:0] shift_lsl_lsr,
    output [3:0]offset_ldr_str,
    output [15:0] ALU_output,*/
   // input [2:0]address_reg_bank
    );
    
    wire [14:0] pc_data;
    wire [4:0]d_data;
    wire [14:0] mem_data;
 //   wire [4:0]  opcode_data;
 //   wire [3:0]  operand_addr_data;
 //   wire [1:0]  addr_mode_data;
    wire [3:0]  branch_offset_value;
//    wire [3:0]  ldr_str_offset_value;
//    wire [6:0]  immediate_value_movi;
    wire [14:0] data_mux_2_to_reg_bank;
    wire [14:0] data_1;
    wire [14:0] data_2;
    wire [14:0] data_2_1;
    wire [14:0] alu_data;
    wire flag;

    PC_Module PC(.clk(clk), .incr_PC(incr_pc),.PC_pointer(pc_data),
    .branch_offset(branch_offset_en),.offset_value(branch_offset_value),.reset_pc(reset_pc));
    
     
    MEMORY_Module MEMORY(.clk(clk),.address(pc_data),.data_out(mem_data),.write_data(write_data),
    .read_data(read_data),.data_in(mem_input_data),.incr_pc_write(incr_pc_write),.instr_written(instr_written));
    
    INSTRN_Dcoder_Module IDECODER(.clk(clk),.instruction(mem_data),.instrn_decode(instrn_decode),
    .opcode(opcode),.operand_addr(operand_addr),.operand_addr_mode(operand_addr_mode),
    .branch_offset_value(branch_offset_value),.start(start)/*,.immediate_data_mov(immediate_value_movi),
    .shift_lsl_lsr(shift_lsl_lsr),.offset_ldr_str(offset_ldr_str)*/);    
    
    
     DATA_MEMORY_Module DMEMORY(.clk(clk),.incr_data_write(incr_data_write),.incr_data_read(incr_data_read),.data_out(d_mem_data),
    .read_flag(read_flag),.write_flag(write_flag),.data_in(d_mem_input_data),.ptr_diff(ptr_diff),.reset(reset));
    
    /*REGISTER_BANK_MODULE REG_BANK(.address_1(operand_1),.address(address_reg_bank),
    .read_write_reg_bank(read_write_data),.clk(clk),.reg_data_1(data_1), .data(mem_input_data));
    
     alu ALU(.clk(clk),.sel(opcode_data),.ALU_result(alu_data));

    
    MUX_2_MODULE MUX_2(.data_2_reg(data_2),.immediate_data(immediate_value_movi),.memory_data(mem_data),
    .alu_data(alu_data),.mux_2_sel(mux_2_sel),.mux_2_output(data_mux_2_to_reg_bank),.clk(clk));
    
    MUX_1_MODULE MUX_1(.shift_value(shift_lsl_lsr),.immediate_value(immediate_value_movi)
    ,.offset_value(offset_ldr_str),.reg_bank_value(data_2),.clk(clk),.mux_1_sel(mux_1_sel)
    ,.mux_1_output(data_2_1));*/
    
   // assign opcode = opcode_data;
  //  assign operand_2 = operand_2_data;
  //  assign operand_1 = operand_1_data;
    //assign ALU_output = alu_data;
    
    

endmodule

