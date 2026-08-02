`timescale 1ns/1ps

module control_unit_tb;

reg [6:0] opcode;

wire branch;
wire mem_read;
wire mem_to_reg;
wire [1:0] alu_op;
wire mem_write;
wire alu_src;
wire reg_write;
wire jump;

control_unit uut(
    .opcode(opcode),
    .branch(branch),
    .mem_read(mem_read),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .jump(jump)
);

initial begin

    $dumpfile("waveforms/control_unit.vcd");
    $dumpvars(0, control_unit_tb);

    $monitor(
        "Time=%0t opcode=%h reg_write=%b alu_src=%b mem_read=%b mem_write=%b mem_to_reg=%b branch=%b jump=%b alu_op=%b",
        $time,
        opcode,
        reg_write,
        alu_src,
        mem_read,
        mem_write,
        mem_to_reg,
        branch,
        jump,
        alu_op
    );

    // R-Type
    opcode = 7'b0110011;
    #10;

    // I-Type (ADDI)
    opcode = 7'b0010011;
    #10;

    // LW
    opcode = 7'b0000011;
    #10;

    // SW
    opcode = 7'b0100011;
    #10;

    // BEQ
    opcode = 7'b1100011;
    #10;

    // LUI
    opcode = 7'b0110111;
    #10;

    // JAL
    opcode = 7'b1101111;
    #10;

    // Invalid
    opcode = 7'b1111111;
    #10;

    $finish;

end

endmodule