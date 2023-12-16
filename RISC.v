`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:49:10 PM
// Design Name: 
// Module Name: RISC
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

module RISC(
input clk,
input start,
input wire [14:0]instr_in,
input [127:0]data_ins,
input data_done,
input [14:0]data_no,
input private_key_new,
input randomize,
input AES_key_new,
output FINAL_OUTPUT
);
    
    wire [14:0] pc_data;
    wire [14:0] mem_data;
   // wire [4:0]  opcode;
    wire [3:0]  branch_offset_value;
  /*  wire [3:0]  ldr_str_offset_value;
    wire [6:0]  immediate_value_movi;
    wire [15:0] data_mux_2_to_reg_bank;*/
    wire [14:0] mem_input_data;
    wire [14:0] data_1;
    wire [14:0] data_2;
    wire [14:0] data_2_1;
    wire [14:0] alu_data;
    wire flag;
    wire incr_pc;
    wire branch_offset_en;
    wire read_data,write_data,read_flag,write_flag;
    wire instrn_decode;
    wire [4:0]opcode;
    wire [14:0]d_in;
    wire [127:0]d_data_in;
    wire [127:0]operand_1;
    wire RSA_E,RSA_D,AES_E,AES_D;
    wire [3:0]operand_addr;
    wire [1:0]operand_addr_mode;
    wire RSA_Encryption_done,RSA_Decryption_done,AES_Encryption_done,AES_Decryption_done;
    wire start_op;
    wire [127:0]data_value;
    wire incr_data_write;
    wire reset_pc;
    wire new_data;
    wire incr_data_read;
    wire [1:0]ptr_diff;
    wire incr_pc_write;
    wire instr_written;
    wire [127:0]OUT_ae;
    wire [127:0]OUT_ad;
    wire [255:0]result;
    
    CONTROL_PATH_MODULE_1 cont( .clk(clk), .reset(start), .opcode(opcode), 
    .incr_pc(incr_pc), .branch_offset_en(branch_offset_en),.read_data(read_data),.write_data(write_data),.read_flag(read_flag),
    .write_flag(write_flag),.instrn_decode(instrn_decode),.instr_in(instr_in), .mem_inp_data(d_in),.d_mem_input_data(d_data_in), 
    .operand_1(operand_1),.RSA_Encryption_flag(RSA_E),.RSA_Decryption_flag(RSA_D), .AES_Encryption_flag(AES_E), .AES_Decryption_flag(AES_D),
    .operand_addr(operand_addr),.operand_addr_mode(operand_addr_mode),.rsa_encdone(RSA_Encryption_done),.rsa_decdone(RSA_Decryption_done),
    .aes_encdone(AES_Encryption_done), .aes_decdone(AES_Decryption_done),.start_op(start_op),.data_mem_in(data_value),.data_input(data_ins),
    .incr_data_write(incr_data_write),.data_done(data_done),.reset_pc(reset_pc),.new_data(new_data), .incr_data_read(incr_data_read),
    .ptr_diff(ptr_diff),.incr_pc_write(incr_pc_write),.data_no(data_no),.instr_written(instr_written));
    
    DATA_PATH_MODULE_1 datum(.clk(clk), .incr_pc(incr_pc),.read_data(read_data),.write_data(write_data),.read_flag(read_flag),
    .write_flag(write_flag),.mem_input_data(d_in),.d_mem_input_data(d_data_in),.instrn_decode(instrn_decode),.branch_offset_en(branch_offset_en), .opcode(opcode), .operand_addr_mode(operand_addr_mode),
    .operand_addr(operand_addr),.start(start_op),.d_mem_data(data_value),.incr_data_write(incr_data_write),.reset_pc(reset_pc),
    .incr_data_read(incr_data_read),.ptr_diff(ptr_diff),.reset(start),.incr_pc_write(incr_pc_write),.instr_written(instr_written));
    
    CryptoKnight CK1(.Master_clk(clk),.Master_reset(start), .operand_1(operand_1),.RSA_Encryption_flag(RSA_E),
    .RSA_Decryption_flag(RSA_D), .AES_Encryption_flag(AES_E), .AES_Decryption_flag(AES_D), .enc_flag(RSA_Encryption_done),
    .dec_flag(RSA_Decryption_done),.AES_Encryption_correct(AES_Encryption_done), .AES_Decryption_correct(AES_Decryption_done),
    .new_data(new_data),.randomize(randomize),.AES_key_new(AES_key_new),
    .private_key_new(private_key_new),.FINAL_OUTPUT(FINAL_OUTPUT));
    
endmodule
