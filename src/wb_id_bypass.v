`timescale 1ns/1ps

module wb_id_bypass(
    input [4:0] id_rs1,
    input [4:0] id_rs2,

    input [4:0] mem_wb_rd,
    input mem_wb_reg_write,
    input [31:0] mem_wb_write_data,

    input [31:0] rf_read_data1,
    input [31:0] rf_read_data2,
    output [31:0] read_data1,
    output [31:0] read_data2

);


wire bypass_rs1 = mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_rs1);
wire bypass_rs2 = mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_rs2);

assign read_data1 = bypass_rs1 ? mem_wb_write_data : rf_read_data1;
assign read_data2 = bypass_rs2 ? mem_wb_write_data : rf_read_data2;


endmodule
    