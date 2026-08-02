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

endmodule