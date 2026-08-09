`timescale 1ns/1ps

module forwarding_unit(
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,

    input [4:0] ex_mem_rd,
    input ex_mem_reg_write,

    input [4:0] mem_wb_rd,
    input mem_wb_reg_write,

    output [1:0] forward_a,
    output [1:0] forward_b
);

wire a_from_exmem = ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs1);
wire a_from_memwb = mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs1);
wire b_from_exmem = ex_mem_reg_write && (ex_mem_rd != 5'd0) && (ex_mem_rd == id_ex_rs2);
wire b_from_memwb = mem_wb_reg_write && (mem_wb_rd != 5'd0) && (mem_wb_rd == id_ex_rs2);

assign forward_a = a_from_exmem ? 2'b10 : a_from_memwb ? 2'b01 : 2'b00;
assign forward_b = b_from_exmem ? 2'b10 : b_from_memwb ? 2'b01 : 2'b00;

endmodule