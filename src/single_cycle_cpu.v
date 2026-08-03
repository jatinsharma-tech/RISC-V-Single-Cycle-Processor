`timescale 1ns/1ps
module single_cycle_cpu(
    input clk,
    input reset,

    // Debug taps for x1-x4, exposed for waveform/testbench visibility
    output [31:0] debug_x1,
    output [31:0] debug_x2,
    output [31:0] debug_x3,
    output [31:0] debug_x4
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
wire jalr;
wire lui;
wire auipc;

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
    .jump(jump),
    .jalr(jalr),
    .lui(lui),
    .auipc(auipc)
);


register_file register_file_inst(
    .clk(clk),
    .reg_write(reg_write),
    .rs1(instruction[19:15]),
    .rs2(instruction[24:20]),
    .rd(instruction[11:7]),
    .write_data(write_back_data),
    .read_data1(read_data1),
    .read_data2(read_data2),
    .debug_x1(debug_x1),
    .debug_x2(debug_x2),
    .debug_x3(debug_x3),
    .debug_x4(debug_x4)
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
    .funct3(instruction[14:12]),
    .read_data(memory_data)
);

assign write_back_data = jump   ? (pc + 32'd4) :
                          lui    ? immediate     :
                          auipc  ? (pc + immediate) :
                          mem_to_reg ? memory_data : alu_result;

// --- Branch resolution (BEQ/BNE/BLT/BGE/BLTU/BGEU) ---
// alu_control_inst already picked SUB (eq/ne), SLT (lt/ge, signed) or
// SLTU (ltu/geu, unsigned) for us based on funct3. Now we just read the
// right flag off the ALU and apply the funct3[0] "invert" bit that RISC-V
// uses to turn BEQ->BNE, BLT->BGE, BLTU->BGEU.
wire funct3_2 = instruction[14]; // 1 = ordering compare (LT/GE family), 0 = equality (EQ/NE family)
wire funct3_0 = instruction[12]; // 1 = inverted condition (NE/GE/GEU)
wire compare_value = funct3_2 ? alu_result[0] : zero;
wire branch_taken = branch & (compare_value ^ funct3_0);

// --- Next PC ---
// JALR target is rs1 + imm, computed by the ALU (alu_op=00, alu_src=1),
// with bit 0 cleared per the RISC-V spec.
wire [31:0] jalr_target = {alu_result[31:1], 1'b0};

assign next_pc = jalr                ? jalr_target :
                  (jump || branch_taken) ? (pc + immediate) :
                                            (pc + 32'd4);

endmodule