`timescale 1ns/1ps
module single_cycle_cpu(
    input clk,
    input reset

);

// Program Counter
wire [31:0] pc;
wire [31:0] next_pc;

//Instructions
wire [31:0] instruction;

// Register Files
wire [31:0] read_data1; 
wire [31:0] read_data2;

// Immediate Generator
wire [31:0] immediate;

//CONTROL UNIT
wire branch;
wire mem_read;
wire mem_to_reg;
wire [1:0] alu_op;
wire mem_write;
wire alu_src;
wire reg_write;
wire jump;

//ALU Control
wire [3:0] alu_control;

//ALU
wire [31:0] alu_result;
wire zero;

//Data Memory
wire [31:0] memory_data;

//ALU MUX
wire [31:0] alu_input2;

//Write Back MUX
wire [31:0] write_back_data;


pc pc_inst(
    .clk(clk),
    .reset(reset),
    .next_pc(next_pc),
    .pc(pc)
);



instruction_memory instruction_memory_inst(
    .address(pc),
    .instruction(instruction)
);



control_unit control_unit_inst(
    .opcode(instruction[6:0]),
    .branch(branch),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .jump(jump)
);


register_file register_file_inst(
    .clk(clk),
    .reg_write(reg_write),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);


immediate_generator immediate_generator_inst(
    .instruction(instruction),
    .immediate(immediate)
);


alu_control alu_control_inst(
    .alu_op(alu_op),
    .funct3(instruction[14:12]),
    .funct7(instruction[31:25]),
    .alu_control(alu_control)
);


alu alu_inst(
    .a(read_data1),
    .b(alu_input2),
    .alu_control(alu_control),
    .result(alu_result),
    .zero(zero)
);  

assign alu_input2 = (alu_src) ? immediate : read_data2;


data_memory data_memory_inst(
    .clk(clk),
    .address(alu_result),
    .write_data(read_data2),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .read_data(memory_data)
);

assign write_back_data = (mem_to_reg) ? memory_data : alu_result;

assign next_pc = pc + 32'd4;

endmodule