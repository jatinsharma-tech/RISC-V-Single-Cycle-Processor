`timescale 1ns/1ps

module alu_control_tb;

reg [1:0] alu_op;
reg [2:0] funct3;
reg [6:0] funct7;

wire [3:0] alu_control;

alu_control uut(
    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),
    .alu_control(alu_control)
);

initial begin

    $dumpfile("waveforms/alu_control.vcd");
    $dumpvars(0, alu_control_tb);

    // ADD
    alu_op = 2'b10;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    #10;

    // SUB
    alu_op = 2'b10;
    funct3 = 3'b000;
    funct7 = 7'b0100000;
    #10;

    // AND
    funct3 = 3'b111;
    funct7 = 7'b0000000;
    #10;

    // OR
    funct3 = 3'b110;
    #10;

    // XOR
    funct3 = 3'b100;
    #10;

    // SLT
    funct3 = 3'b010;
    #10;

    // LOAD / STORE
    alu_op = 2'b00;
    #10;

    // BRANCH
    alu_op = 2'b01;
    #10;

    $finish;

end

endmodule