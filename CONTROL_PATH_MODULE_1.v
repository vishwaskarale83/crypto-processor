`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 08:50:05 PM
// Design Name: 
// Module Name: CONTROL_PATH_MODULE_1
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

module CONTROL_PATH_MODULE_1(
input clk,
input [14:0]instr_in,
input reset,
input [4:0]opcode,
input [3:0] operand_addr,
input [1:0] operand_addr_mode,
input [127:0]data_mem_in,
input [127:0]data_input,
input data_done,
input rsa_encdone,
input rsa_decdone,
input aes_encdone,
input aes_decdone,
input start_op,
input [1:0]ptr_diff,
input [14:0]data_no,
input instr_written,

output reg [14:0]mem_inp_data,
output reg [127:0]d_mem_input_data,
output reg [127:0] operand_1,
output reg instrn_decode,
output reg branch_offset_en,
output reg incr_pc,
output reg incr_pc_write,
output reg incr_data_write,
output reg incr_data_read,
output reg reset_pc,
output reg read_data=0,
output reg write_data=0,
output reg write_flag=0,
output reg read_flag=0,
output reg new_data = 0,
output reg RSA_Encryption_flag,
output reg RSA_Decryption_flag,
output reg AES_Encryption_flag,
output reg AES_Decryption_flag
);
    
    
    parameter IDLE = 3'b000;
    parameter INSTR_FETCH = 3'b001;
    parameter INSTR_DECODE = 3'b010;
    parameter INITIALIZE = 3'b011;
    parameter OPER_FETCH = 3'b100;
    parameter EXECUTE = 3'b101;
    parameter STORE = 3'b110;
    
    parameter RSA_E = 2'b00;
    parameter RSA_D = 2'b01;
    parameter AES_E = 2'b10;
    parameter AES_D = 2'b11; 
    
    reg [2:0]state;
    reg done = 0;
    reg [18:0]c=0;
    reg [3:0]operation;
    reg start_boot = 0;
    reg [127:0]datas_ins=0;
    reg [14:0]instr_ins_reg=0;
    reg new_d;
    reg [14:0]data_count=0;
    reg [14:0]new_instr_count=0;
    reg [14:0]no_of_data[12:0];
    
    reg [1:0]instr_count=0;
    reg [14:0]temp=0;
    integer x=0,y=0;

    always@(posedge clk) begin
       //read_flag = 1;//always, can make 0 in execute
        write_flag = 0;
        incr_data_write = 0;
        write_data = 0;
        incr_pc_write = 0;
        new_d = 0;
        
        d_mem_input_data = data_input;
        if(datas_ins != data_input)begin
             write_flag = 1;
             incr_data_write = 1; 
             new_d = 1;
        end            
        datas_ins = data_input;
        
        mem_inp_data = instr_in;
        if(instr_ins_reg != instr_in)begin
            incr_pc_write = 1;
            write_data = 1;
            no_of_data[new_instr_count] = data_no;
            new_instr_count = new_instr_count + 1;
        end
        instr_ins_reg = instr_in;
         
             
        if(reset == 1)
            state <= IDLE;
          
        else begin
            case(state)
                IDLE: begin
                    incr_pc <= 0;
                    incr_data_read <= 0;
                    instrn_decode <= 0;
                    reset_pc <= 0;
                    if(instr_written && x < 2)//wait till 1st instruction comes
                        x = x + 1; 
                    if(x > 0)
                        state = INSTR_FETCH;
                    else
                        state = IDLE;    
                    /*if(new_d)
                        state = INSTR_FETCH;
                    else
                        state = IDLE;    */
                       
                end 
                INSTR_FETCH: begin
                    
                    incr_pc <= 1;
                    if(start_op == 1)
                        read_data = 1;    

                    c = c + 1;
                    state = INSTR_DECODE;
                    
                end
                INSTR_DECODE: begin
                    read_data = 0;
                    incr_pc <= 0;
                    instrn_decode <= 1;
                    if(start_op == 1)begin
                        
                        state = OPER_FETCH;
                     end
                    else
                        state = INITIALIZE;
                end
                INITIALIZE: begin
                    instrn_decode <= 0;
                    if(start_op == 1) 
                        state = INSTR_FETCH;
                    else 
                        state = INITIALIZE;
                end
                OPER_FETCH : begin
                instrn_decode <= 0;
             
                 /*   if(opcode == 5'b11111)
                        start_boot = 1;  
                    if(start_boot == 1 && opcode[4] == 1) begin // boot  
                    //if(boot) begin
                        read_write_data = 1;
                        mem_inp_data = instr_in;
                        count = 0;
                        state = STORE;
                    end
                    else begin*/
                       //  start_boot = 0;
                       //  count = count + 1;
                       //  if(count == 1)
                       //     reset_pc = 1;  //make address = 1 for instruction memory
                       //read_write_data = 0;
                       if(ptr_diff == 2) begin
                            incr_data_read = 1;
                            
                            if(operand_1 != data_mem_in)
                                new_data = 1;
                            operand_1 = data_mem_in;
                            state = EXECUTE;
                        end
                      
                    //end
                end
                EXECUTE: begin
                    new_data = 0;
                    incr_data_read = 0; 
                    
                    reset_pc = 0;
                    operation = opcode & 5'b01111;
                    case(operation)
                        RSA_E: begin
                            AES_Encryption_flag = 0;
                            AES_Decryption_flag = 0;
                            RSA_Encryption_flag = 1;
                            RSA_Decryption_flag = 0;
                            if(rsa_encdone == 1) begin
                                done = 1;
                            end    
                        end
                        RSA_D: begin
                            AES_Encryption_flag = 0;
                            AES_Decryption_flag = 0;
                            RSA_Encryption_flag = 0;
                            RSA_Decryption_flag = 1;
                            if(rsa_decdone == 1)begin
                                done = 1;
                            end    
                        end
                        AES_E: begin
                            AES_Encryption_flag = 1;
                            AES_Decryption_flag = 0;
                            RSA_Encryption_flag = 0;
                            RSA_Decryption_flag = 0;
                            if(aes_encdone == 1)begin
                                done = 1;
                            end    
                        end
                        AES_D: begin
                            AES_Encryption_flag = 0;
                            AES_Decryption_flag = 1;
                            RSA_Encryption_flag = 0;
                            RSA_Decryption_flag = 0;
                            if(aes_decdone == 1)begin
                                done = 1;
                            end    
                        end
                        default: begin
                            AES_Encryption_flag = 0;
                            AES_Decryption_flag = 0;
                            RSA_Encryption_flag = 0;
                            RSA_Decryption_flag = 0;
                        end
                       
                    endcase
                    
                    if(done == 1 || operand_1 == 127'd1) 
                        state = STORE; 
                    else if(done == 0) 
                        state = EXECUTE;     
                end
                STORE: begin
                    done = 0;
                    incr_data_read = 0;
                    data_count = data_count + 1;
                    temp = no_of_data[c-2];
                    if(temp == data_count) begin
                        data_count = 0;
                        state = INSTR_FETCH;
                    end
                    else 
                        state = OPER_FETCH;
                    end    
                  
            endcase
        end
    end
    
endmodule

