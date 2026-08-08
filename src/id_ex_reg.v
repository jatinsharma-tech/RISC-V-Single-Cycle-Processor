`timescale 1ns/1ps

module id_ex_reg(
    input clk,
    input reset,
    input stall,
    input flush,

    // DATA
    input [31:0] pc_in,
    input [31:0] pc4_in,
    input [31:0] read_data1_in,
    input [31:0] read_data2_in,
    input [31:0] immediate_in,
    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,
    input [2:0] funct3_in,
    input [6:0] funct7_in,

    // CONTROL
    input branch_in,
    input mem_read_in,
    input mem_to_reg_in,
    input mem_write_in,
    input alu_src_in,
    input reg_write_in,
    input jump_in,
    input jalr_in,
    input lui_in,
    input auipc_in,
    input [1:0]  alu_op_in,

    // REGISTERED DATA
    output reg [31:0] pc_out,
    output reg [31:0] pc4_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] immediate_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,

    // REGISTERED CONTROL
    output reg branch_out,
    output reg mem_read_out,
    output reg mem_to_reg_out,
    output reg mem_write_out,
    output reg alu_src_out,
    output reg reg_write_out,
    output reg jump_out,
    output reg jalr_out,
    output reg lui_out,
    output reg auipc_out,
    output reg [1:0] alu_op_out
);


always @(posedge clk) begin
    if (reset || flush || stall) begin
        pc_out <= 32'd0;
        pc4_out <= 32'd0;
        read_data1_out <= 32'd0;
        read_data2_out <= 32'd0;
        immediate_out <= 32'd0;
        rs1_out <= 5'd0;
        rs2_out <= 5'd0;
        rd_out <= 5'd0;
        funct3_out <= 3'd0;
        funct7_out <= 7'd0;

        branch_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        mem_write_out <= 1'b0;
        alu_src_out <= 1'b0;
        reg_write_out  <= 1'b0;
        jump_out <= 1'b0;
        jalr_out <= 1'b0;
        lui_out <= 1'b0;
        auipc_out <= 1'b0;
        alu_op_out <= 2'b00;
    end else begin
        pc_out <= pc_in;
        pc4_out <= pc4_in;
        read_data1_out <= read_data1_in;
        read_data2_out <= read_data2_in;
        immediate_out <= immediate_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;
        funct3_out <= funct3_in;
        funct7_out <= funct7_in;

        branch_out <= branch_in;
        mem_read_out <= mem_read_in;
        mem_to_reg_out <= mem_to_reg_in;
        mem_write_out <= mem_write_in;
        alu_src_out <= alu_src_in;
        reg_write_out <= reg_write_in;
        jump_out <= jump_in;
        jalr_out <= jalr_in;
        lui_out <= lui_in;
        auipc_out <= auipc_in;
        alu_op_out <= alu_op_in;
    end
end

endmodule