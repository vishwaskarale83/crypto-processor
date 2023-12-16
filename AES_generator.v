`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2020 04:16:01 PM
// Design Name: 
// Module Name: AES_generator
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


module AES_key_generator(clk,continue,new,done,randomizer,p1,p2);

parameter WIDTH = 256;        
parameter seed = 127'd11383815459899755273;

input clk,new;
input [15:0] p1,p2;
input continue;
output reg done;
//output reg randomize_complete;
output reg [127:0] randomizer;
wire [87:0] m_axis_dout_tdata;

wire m_axis_dout_tvalid;
reg [31:0] M = 1;
reg [127:0] var1 = seed;
reg [127:0] var2 = 0;
reg M_calc;
reg flag = 0;

reg s_axis_divisor_tvalid;
reg s_axis_dividend_tvalid;

integer j,k,l;

wire s_axis_divisor_tready;
wire s_axis_dividend_tready;

div_gen_1 remainder (
  .aclk(clk),                                      // input wire aclk
  .s_axis_divisor_tvalid(s_axis_divisor_tvalid),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tready(s_axis_divisor_tready),    // output wire s_axis_divisor_tready
  .s_axis_divisor_tdata(M),      // input wire [63 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(s_axis_dividend_tvalid),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tready(s_axis_dividend_tready),  // output wire s_axis_dividend_tready
  .s_axis_dividend_tdata(var1[63:0]),    // input wire [63 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(m_axis_dout_tdata)            // output wire [79 : 0] m_axis_dout_tdata
);


always@(posedge clk) begin
    if(new == 1) begin
        done = 0;
        //randomize_complete = 0;
        j = 0;
        randomizer = 0;
        l = 10;
        if (continue == 1)
            l = 0;
        M = 0;
        M_calc = 1;
        s_axis_dividend_tvalid = 0;
        s_axis_divisor_tvalid = 0;
    end 
    
    else if (M_calc == 1 && new == 0) begin
        for (j = 0;j<16;j = j + 1) begin
            if (p1[j] == 1)
                M = M + p2*(2**j);
        end
        j = 0;
        M_calc = 0;
        s_axis_dividend_tvalid = 1;
        s_axis_divisor_tvalid = 1;

        if (continue == 1)
            l = 0;
        else 
            l = 10;
    end
    
    else begin
        if ((j < 128 || (continue && l < 10)) && m_axis_dout_tvalid && ~flag) begin
            for (k = 0;k<64;k = k + 1) begin
                if (var1[k] == 1)
                    var1[127:63] = var1[127:64] + var1*(2**k);
            end
            s_axis_dividend_tvalid = 0;
            s_axis_divisor_tvalid = 0;
             

            var1 = {m_axis_dout_tdata[17:0],var1[80:63],var1[98:81],m_axis_dout_tdata[9:0]};
                                    
            if (continue == 0) begin
                for (l = 0;l < 16;l = l + 1)
                    var2[l+j] = var1[l];
                j = j + 16;
                l = 0;
            end
            if (continue == 1 ) begin
                j = 1000;
                randomizer = {var1[63:0],~var1[63:0]};
                l = l + 1;

            end
            flag = 1;
        end
        
        else if (~m_axis_dout_tvalid && ~new && (j < 128 || (continue && l < 10)) ) begin
            s_axis_dividend_tvalid = 1;
            s_axis_divisor_tvalid = 1;
            flag = 0;
        end
        
        else begin
            if (continue == 0 && j == 128) begin
                randomizer = var2;
                s_axis_dividend_tvalid = 0;
                s_axis_divisor_tvalid = 0;
                done = 1;
            end
            if (l == 10) begin
                s_axis_dividend_tvalid = 0;
                s_axis_divisor_tvalid = 0;                
                //randomize_complete = 1;
            end
        end
    end
end
endmodule