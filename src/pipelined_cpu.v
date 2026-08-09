`timescale 1ns/1ps

module pipelined_cpu(
    input clk,
    input reset,
    output [31:0] debug_x1,
    output [31:0] debug_x2,
    output [31:0] debug_x3,
    output [31:0] debug_x4
);

//PROGRAM COUNTER

reg [31:0] pc;
wire stall;
wire flush;
wire [31:0] pc_plus4 = pc + 32'd4;
wire [31:0] flush_target;

always @(posedge clk) begin
    if (reset)
        pc <= 32'd0;
    else if (flush)
        pc <= flush_target;
    else if (!stall)
        pc <= pc_plus4;

end


//IF stage

wire [31:0]  if_instruction;

instruction_memory instruction_memory_inst(
    .address(pc),
    .instruction(if_instruction)
);

wire [31:0] if_id_pc, if_id_pc4, if_id_instr;

if_id_reg if_id_reg_inst(
    .clk(clk),
    .reset(reset),
    .stall(stall),
    .flush(flush),

    .pc_in(pc),
    .pc4_in(pc_plus4),
    .instr_in(if_instruction),

    .pc_out(if_id_pc),
    .pc4_out(if_id_pc4),
    .instr_out(if_id_instr)
);


//ID STAGe
wire [6:0] id_opcode = if_id_instr[6:0];
wire [4:0] id_rs1 = if_id_instr[19:15];
wire [4:0] id_rs2 = if_id_instr[24:20];
wire [4:0] id_rd = if_id_instr[11:7];
wire [2:0] id_funct3 = if_id_instr[14:12];
wire [6:0] id_funct7 = if_id_instr[31:25];

wire id_branch, id_mem_read, id_mem_to_reg, id_mem_write;
wire id_alu_src, id_reg_write, id_jump, id_jalr, id_lui, id_auipc;
wire [1:0] id_alu_op;



control_unit control_unit_inst(
    .opcode(id_opcode),
    .branch(id_branch),
    .mem_read(id_mem_read),
    .mem_to_reg(id_mem_to_reg),
    .alu_op(id_alu_op),
    .mem_write(id_mem_write),
    .alu_src(id_alu_src),
    .reg_write(id_reg_write),
    .jump(id_jump),
    .jalr(id_jalr),
    .lui(id_lui),
    .auipc(id_auipc)
);

wire [31:0] id_immediate;

immediate_generator immediate_generator_inst(
    .instruction(if_id_instr),
    .immediate(id_immediate)
);
wire [31:0] rf_read_data1, rf_read_data2;

register_file register_file_inst(
    .clk(clk),
    .reg_write(mem_wb_reg_write),
    .rs1(id_rs1),
    .rs2(id_rs2),
    .rd(mem_wb_rd),
    .write_data(wb_write_back_data),
    .read_data1(rf_read_data1),
    .read_data2(rf_read_data2),
    .debug_x1(debug_x1),
    .debug_x2(debug_x2),
    .debug_x3(debug_x3),
    .debug_x4(debug_x4)
);

wire [31:0] id_read_data1, id_read_data2;

wd_id_bypass wd_id_bypass_inst(
    .id_rs1(id_rs1),
    .id_rs2(id_rs2),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .mem_wb_write_data(wb_write_back_data),
    .rf_read_data1(rf_read_data1),
    .rf_read_data2(rf_read_data2),
    .read_data1(id_read_data1),
    .read_data2(id_read_data2)
);

hazard_unit hazard_unit_inst(
    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_rd(id_ex_rd),
    id_rs1(id_rs1),
    id_rs2(id_rs2),
    .stall(stall)
);

wire [31:0] id_ex_pc, id_ex_pc4, id_ex_read_data1, id_ex_read_data2, id_ex_immediate;
wire [4:0]  id_ex_rs1, id_ex_rs2, id_ex_rd;
wire [2:0]  id_ex_funct3;
wire [6:0]  id_ex_funct7;
wire id_ex_branch, id_ex_mem_read, id_ex_mem_to_reg, id_ex_mem_write;
wire id_ex_alu_src, id_ex_reg_write, id_ex_jump, id_ex_jalr;
wire id_ex_lui, id_ex_auipc;
wire [1:0] id_ex_alu_op;


id_ex_reg id_ex_reg_inst(
    .clk(clk),
    .reset(reset),
    .stall(stall),
    .flush(flush),

    .pc_in(if_id_pc),
    .pc4_in(if_id_pc4),
    .read_data1_in(id_read_data1),
    .read_data2_in(id_read_data2),
    .immediate_in(id_immediate),
    .rs1_in(id_rs1),
    .rs2_in(id_rs2),
    .rd_in(id_rd),
    .funct3_in(id_funct3),
    .funct7_in(id_funct7),

    .branch_in(id_branch),
    .mem_read_in(id_mem_read),
    .mem_to_reg_in(id_mem_to_reg),
    .mem_write_in(id_mem_write),
    .alu_src_in(id_alu_src),
    .reg_write_in(id_reg_write),
    .jump_in(id_jump),
    .jalr_in(id_jalr),
    .lui_in(id_lui),
    .auipc_in(id_auipc),
    .alu_op_in(id_alu_op),

    .pc_out(id_ex_pc),
    .pc4_out(id_ex_pc4),
    .read_data1_out(id_ex_read_data1),
    .read_data2_out(id_ex_read_data2),
    .immediate_out(id_ex_immediate),
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),
    .rd_out(id_ex_rd),
    .funct3_out(id_ex_funct3),
    .funct7_out(id_ex_funct7),

    .branch_out(id_ex_branch),
    .mem_read_out(id_ex_mem_read),
    .mem_to_reg_out(id_ex_mem_to_reg),
    .mem_write_out(id_ex_mem_write),
    .alu_src_out(id_ex_alu_src),
    .reg_write_out(id_ex_reg_write),
    .jump_out(id_ex_jump),
    .jalr_out(id_ex_jalr),
    .lui_out(id_ex_lui),
    .auipc_out(id_ex_auipc),
    .alu_op_out(id_ex_alu_op)
);
    