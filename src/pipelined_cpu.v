`timescale 1ns/1ps
module pipelined_cpu(
    input clk,
    input reset,

    output [31:0] debug_x1,
    output [31:0] debug_x2,
    output [31:0] debug_x3,
    output [31:0] debug_x4
);
reg [31:0] pc;
wire        stall;
wire        flush;
wire [31:0] pc_plus4;
wire [31:0] flush_target;

wire [31:0] if_instruction;
wire [31:0] if_id_pc, if_id_pc4, if_id_instr;

wire [6:0] id_opcode;
wire [4:0] id_rs1, id_rs2, id_rd;
wire [2:0] id_funct3;
wire [6:0] id_funct7;

wire id_branch, id_mem_read, id_mem_to_reg, id_mem_write;
wire id_alu_src, id_reg_write, id_jump, id_jalr, id_lui, id_auipc;
wire [1:0] id_alu_op;

wire [31:0] id_immediate;
wire [31:0] rf_read_data1, rf_read_data2;
wire [31:0] id_read_data1, id_read_data2;

wire [31:0] id_ex_pc, id_ex_pc4, id_ex_read_data1, id_ex_read_data2, id_ex_immediate;
wire [4:0]  id_ex_rs1, id_ex_rs2, id_ex_rd;
wire [2:0]  id_ex_funct3;
wire [6:0]  id_ex_funct7;
wire        id_ex_branch, id_ex_mem_read, id_ex_mem_to_reg, id_ex_mem_write;
wire        id_ex_alu_src, id_ex_reg_write, id_ex_jump, id_ex_jalr;
wire        id_ex_lui, id_ex_auipc;
wire [1:0]  id_ex_alu_op;

wire [1:0] forward_a, forward_b;
wire [31:0] ex_operand_a;
wire [31:0] ex_operand_b_reg;
wire [31:0] ex_alu_input2;
wire [3:0]  ex_alu_control;
wire [31:0] ex_alu_result;
wire        ex_zero;
wire ex_funct3_2, ex_funct3_0, ex_compare_value, ex_branch_taken;
wire [31:0] ex_branch_jal_target, ex_jalr_target;
wire [31:0] ex_result;

wire [31:0] ex_mem_ex_result, ex_mem_store_data;
wire [4:0]  ex_mem_rd;
wire [2:0]  ex_mem_funct3;
wire        ex_mem_reg_write, ex_mem_mem_read, ex_mem_mem_write, ex_mem_mem_to_reg;

wire [31:0] mem_memory_data;

wire [31:0] mem_wb_ex_result, mem_wb_memory_data;
wire [4:0]  mem_wb_rd;
wire        mem_wb_reg_write, mem_wb_mem_to_reg;

wire [31:0] wb_write_back_data;


// Program Counter

assign pc_plus4 = pc + 32'd4;

always @(posedge clk) begin
    if (reset)
        pc <= 32'd0;
    else if (flush)
        pc <= flush_target;
    else if (!stall)
        pc <= pc_plus4;
end


// IF stage

instruction_memory instruction_memory_inst(
    .address(pc),
    .instruction(if_instruction)
);

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


// ID stage

assign id_opcode = if_id_instr[6:0];
assign id_rs1    = if_id_instr[19:15];
assign id_rs2    = if_id_instr[24:20];
assign id_rd     = if_id_instr[11:7];
assign id_funct3 = if_id_instr[14:12];
assign id_funct7 = if_id_instr[31:25];

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

immediate_generator immediate_generator_inst(
    .instruction(if_id_instr),
    .immediate(id_immediate)
);

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

wb_id_bypass wb_id_bypass_inst(
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
    .id_rs1(id_rs1),
    .id_rs2(id_rs2),
    .stall(stall)
);

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


// EX stage

forwarding_unit forwarding_unit_inst(
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .ex_mem_rd(ex_mem_rd),
    .ex_mem_reg_write(ex_mem_reg_write),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_reg_write(mem_wb_reg_write),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

assign ex_operand_a =
    (forward_a == 2'b10) ? ex_mem_ex_result :
    (forward_a == 2'b01) ? wb_write_back_data :
                            id_ex_read_data1;

assign ex_operand_b_reg =
    (forward_b == 2'b10) ? ex_mem_ex_result :
    (forward_b == 2'b01) ? wb_write_back_data :
                            id_ex_read_data2;

assign ex_alu_input2 = id_ex_alu_src ? id_ex_immediate : ex_operand_b_reg;

alu_control alu_control_inst(
    .alu_op(id_ex_alu_op),
    .funct3(id_ex_funct3),
    .funct7(id_ex_funct7),
    .alu_control(ex_alu_control)
);

alu alu_inst(
    .a(ex_operand_a),
    .b(ex_alu_input2),
    .alu_control(ex_alu_control),
    .result(ex_alu_result),
    .zero(ex_zero)
);

assign ex_funct3_2 = id_ex_funct3[2];
assign ex_funct3_0 = id_ex_funct3[0];
assign ex_compare_value = ex_funct3_2 ? ex_alu_result[0] : ex_zero;
assign ex_branch_taken  = id_ex_branch & (ex_compare_value ^ ex_funct3_0);

assign ex_branch_jal_target = id_ex_pc + id_ex_immediate;
assign ex_jalr_target       = {ex_alu_result[31:1], 1'b0};

assign flush        = id_ex_jump | ex_branch_taken;
assign flush_target = id_ex_jalr ? ex_jalr_target : ex_branch_jal_target;

assign ex_result =
    id_ex_jump  ? id_ex_pc4 :
    id_ex_lui   ? id_ex_immediate :
    id_ex_auipc ? (id_ex_pc + id_ex_immediate) :
                  ex_alu_result;

ex_mem_reg ex_mem_reg_inst(
    .clk(clk),
    .reset(reset),
    .ex_result_in(ex_result),
    .store_data_in(ex_operand_b_reg),
    .rd_in(id_ex_rd),
    .funct3_in(id_ex_funct3),
    .reg_write_in(id_ex_reg_write),
    .mem_read_in(id_ex_mem_read),
    .mem_write_in(id_ex_mem_write),
    .mem_to_reg_in(id_ex_mem_to_reg),
    .ex_result_out(ex_mem_ex_result),
    .store_data_out(ex_mem_store_data),
    .rd_out(ex_mem_rd),
    .funct3_out(ex_mem_funct3),
    .reg_write_out(ex_mem_reg_write),
    .mem_read_out(ex_mem_mem_read),
    .mem_write_out(ex_mem_mem_write),
    .mem_to_reg_out(ex_mem_mem_to_reg)
);


// MEM stage

data_memory data_memory_inst(
    .clk(clk),
    .mem_write(ex_mem_mem_write),
    .mem_read(ex_mem_mem_read),
    .funct3(ex_mem_funct3),
    .address(ex_mem_ex_result),
    .write_data(ex_mem_store_data),
    .read_data(mem_memory_data)
);

mem_wb_reg mem_wb_reg_inst(
    .clk(clk),
    .reset(reset),
    .ex_result_in(ex_mem_ex_result),
    .memory_data_in(mem_memory_data),
    .rd_in(ex_mem_rd),
    .reg_write_in(ex_mem_reg_write),
    .mem_to_reg_in(ex_mem_mem_to_reg),
    .ex_result_out(mem_wb_ex_result),
    .memory_data_out(mem_wb_memory_data),
    .rd_out(mem_wb_rd),
    .reg_write_out(mem_wb_reg_write),
    .mem_to_reg_out(mem_wb_mem_to_reg)
);


// WB stage

assign wb_write_back_data = mem_wb_mem_to_reg ? mem_wb_memory_data : mem_wb_ex_result;

endmodule